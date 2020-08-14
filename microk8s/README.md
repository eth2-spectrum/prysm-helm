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