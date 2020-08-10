Needs to be built for linux/arm64v8 when deploying to a raspberry pi.
Experimental features (docker ce >=19.03) must be enabled to be able to perform this build.

The following packages must be installed
```shell script
sudo apt-get install -y qemu binfmt-support qemu-user-static
```

Then a new buildx builder has to be created and used
```shell script
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx create --name builder
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx use builder
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx inspect --bootstrap builder
```

The following command builds and pushes an arm64 wrapper of the prysm.sh script.
Please note that the target repository is hardcoded right now. Adjust according to your docker registry.
```shell script
cd prysm
./build_prysm.sh
```

The following command builds a native arm64 binary of the desired prysm process from scratch.
Please inspect the build script for possible customizations.
```shell script
cd prysm-scratch
./build_prysm.sh
```


The following command build an arm64 image of the v.1.19.18 go ethereum client.
```shell script
cd ethnode
./build_ethnode.sh
```
