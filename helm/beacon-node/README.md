
Ports 13000/tcp and 12000/udp are currently not exposed via ingresses. 
If you run an nginx ingress and wish to do this,
you can follow the
[official documentation](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/).
As a side note, make sure that your ingress controller is parameterized with the tcp/udp configmaps on startup.

As you can see below, the ingress plugin from microk8s does not set tcp/udp configmap parameters:

<pre><code>
> $ k describe po -n ingress
Name:         nginx-ingress-microk8s-controller-mn6f4
Namespace:    ingress
Priority:     0
Node:         ubuntu/192.168.178.31
Start Time:   Mon, 10 Aug 2020 00:51:54 +0200
Labels:       controller-revision-hash=684488546b
              name=nginx-ingress-microk8s
              pod-template-generation=1
Annotations:  <none>
Status:       Running
IP:           192.168.178.31
IPs:
  IP:           192.168.178.31
Controlled By:  DaemonSet/nginx-ingress-microk8s-controller
Containers:
  nginx-ingress-microk8s:
    Container ID:  containerd://103015f0def0c430acc1e89e33aa25b4a2589e5ef8e4590564363d94fefcfb54
    Image:         quay.io/kubernetes-ingress-controller/nginx-ingress-controller-arm64:0.25.1
    Image ID:      sha256:7b359835003c9c3224f1a466c17c31985c20f6933cd987f20d3f49455eb52370
    Ports:         80/TCP, 443/TCP
    Host Ports:    80/TCP, 443/TCP
    <strong>Args:
      /nginx-ingress-controller
      --configmap=$(POD_NAMESPACE)/nginx-load-balancer-microk8s-conf
      --publish-status-address=127.0.0.1</strong>
    State:          Running
      Started:      Fri, 14 Aug 2020 17:49:37 +0200
    Last State:     Terminated
      Reason:       Unknown
      Exit Code:    255
      Started:      Fri, 14 Aug 2020 15:40:13 +0200
      Finished:     Fri, 14 Aug 2020 17:49:23 +0200
    Ready:          True
    Restart Count:  19
    Liveness:       http-get http://:10254/healthz delay=30s timeout=5s period=10s #success=1 #failure=3
    Environment:
      POD_NAME:       nginx-ingress-microk8s-controller-mn6f4 (v1:metadata.name)
      POD_NAMESPACE:  ingress (v1:metadata.namespace)
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from nginx-ingress-microk8s-serviceaccount-token-k92qx (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  nginx-ingress-microk8s-serviceaccount-token-k92qx:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  nginx-ingress-microk8s-serviceaccount-token-k92qx
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/disk-pressure:NoSchedule
                 node.kubernetes.io/memory-pressure:NoSchedule
                 node.kubernetes.io/network-unavailable:NoSchedule
                 node.kubernetes.io/not-ready:NoExecute
                 node.kubernetes.io/pid-pressure:NoSchedule
                 node.kubernetes.io/unreachable:NoExecute
                 node.kubernetes.io/unschedulable:NoSchedule
Events:          <none>
</pre></code>