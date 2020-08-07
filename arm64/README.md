Needs to be built for linux/arm64v8 when deploying to a raspberry pi.
Experimental features (docker ce >=19.03) must be enabled to be able to perform this build.

The following packages must be installed as well
```shell script
sudo apt-get install -y qemu binfmt-support qemu-user-static
```

Then a new buildx builder has to be created and used
```shell script
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx create --name builder
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx use builder
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx inspect --bootstrap builder
```

