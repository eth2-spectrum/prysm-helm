Add the following lines to `/boot/firmware/nobtcmd.txt`
```shell script
cgroup_enable=memory cgroup_memory=1
```

and `/boot/firmware/cmdline.txt`
```shell script
net.ifnames=0 dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=LABEL=writable rootfstype=ext4 elevator=deadline rootwait fixrtc cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1
```

to enable cgroups for microk8s on a raspberry pi.

Enable the following plugins 
```shell script
microk8s enable dashboard
microk8s enable dns
microk8s enable prometheus
microk8s enable helm3
microk8s enable ingress
microk8s enable storage
```

## TCP-/UDP Ingress
In order to get other nodes to connect to your beacon node, you need make sure, that the ports 13000/TCP and 12000/UDP
are open to the outside.
In this example, the nginx ingress already enabled is the weapon of choice. For both ports, the traffic flow will look
roughly like this:
```
internet -> host machine -> nginx-ingress-controller -> beacon-node-service -> beacon-node-pod
```
Following the
[official documentation](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/), we have to 
parameterize the ingress controller with config maps containing the routing decisions for the opened ports. Therefore
we start by creating the according config maps in the ingress namespace:
```shell script
$ kubectl apply -n ingress -f ./ingress-tcp-services-configmap.yaml
$ kubectl apply -n ingress -f ./ingress-udp-services-configmap.yaml
```

Further, the default implementation of the microk8s ingress controller daemonset is not parameterized with the created
configmaps. In the example below, the highlighted lines have to be added:
<pre><code>
$ kubectl describe -n ingress daemonsets.apps nginx-ingress-microk8s-controller
Name:           nginx-ingress-microk8s-controller
Selector:       name=nginx-ingress-microk8s
Node-Selector:  &lt;none&gt;
Labels:         microk8s-application=nginx-ingress-microk8s
Annotations:    deprecated.daemonset.template.generation: 3
                kubectl.kubernetes.io/last-applied-configuration:
                  {"apiVersion":"apps/v1","kind":"DaemonSet","metadata":{"annotations":{},"labels":{"microk8s-application":"nginx-ingress-microk8s"},"name":...
Desired Number of Nodes Scheduled: 1
Current Number of Nodes Scheduled: 1
Number of Nodes Scheduled with Up-to-date Pods: 1
Number of Nodes Scheduled with Available Pods: 1
Number of Nodes Misscheduled: 0
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           name=nginx-ingress-microk8s
  Service Account:  nginx-ingress-microk8s-serviceaccount
  Containers:
   nginx-ingress-microk8s:
    Image:       quay.io/kubernetes-ingress-controller/nginx-ingress-controller-arm64:0.25.1
    Ports:       80/TCP, 443/TCP
    Host Ports:  80/TCP, 443/TCP
    Args:
      /nginx-ingress-controller
      --configmap=$(POD_NAMESPACE)/nginx-load-balancer-microk8s-conf
      --publish-status-address=127.0.0.1
      <strong>--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services
      --udp-services-configmap=$(POD_NAMESPACE)/udp-services</strong>
    Liveness:  http-get http://:10254/healthz delay=30s timeout=5s period=10s #success=1 #failure=3
    Environment:
      POD_NAME:        (v1:metadata.name)
      POD_NAMESPACE:   (v1:metadata.namespace)
    Mounts:           &lt;none&gt;
  Volumes:            &lt;none&gt;
Events:
  Type    Reason            Age   From                  Message
  ----    ------            ----  ----                  -------
  Normal  SuccessfulCreate  29m   daemonset-controller  Created pod: nginx-ingress-microk8s-controller-8t9p9
</code></pre>

We therefore have to edit the daemonset, i.e. with the following command:
```shell script
$ kubectl edit -n ingress daemonsets.apps nginx-ingress-microk8s-controller
```

Afterwards we have to restart the ingress controller by deleting the controller pod:
```shell script
kubectl delete -n ingress po nginx-ingress-microk8s-controller-<pod-id>
```

if everything worked out, you can see in the logs that the according configmaps were loaded. Check with:
```shell script
$ kubectl logs -n ingress nginx-ingress-microk8s-<pod-id> | grep "'CREATE' ConfigMap ingress"
I0819 20:56:49.807074       7 event.go:258] Event(v1.ObjectReference{Kind:"ConfigMap", Namespace:"ingress", Name:"tcp-services", UID:"5b280307-8969-4b00-916d-4f26fd4c6a3c", APIVersion:"v1", ResourceVersion:"2636901", FieldPath:""}): type: 'Normal' reason: 'CREATE' ConfigMap ingress/tcp-services
I0819 20:56:49.810126       7 event.go:258] Event(v1.ObjectReference{Kind:"ConfigMap", Namespace:"ingress", Name:"nginx-load-balancer-microk8s-conf", UID:"51384a02-9989-447d-819f-9cbc6d6a8b93", APIVersion:"v1", ResourceVersion:"2569059", FieldPath:""}): type: 'Normal' reason: 'CREATE' ConfigMap ingress/nginx-load-balancer-microk8s-conf
I0819 20:56:49.832790       7 event.go:258] Event(v1.ObjectReference{Kind:"ConfigMap", Namespace:"ingress", Name:"udp-services", UID:"33a70fe1-1467-4676-ad7a-53755d8d0909", APIVersion:"v1", ResourceVersion:"2639337", FieldPath:""}): type: 'Normal' reason: 'CREATE' ConfigMap ingress/udp-services
```

And verify with netcat that the ports are in fact open, and are being routed to the beacon node:
```shell script
$ nc -z -v <host-machine> 13000                                                                                                                                      [±master ●●]
Connection to <host-machine> 13000 port [tcp/*] succeeded!
$ nc -z -v -u <host-machine> 12000                                                                                                                                   [±master ●●]
Connection to <host-machine> 12000 port [udp/*] succeeded!
```