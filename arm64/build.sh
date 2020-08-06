#!/usr/bin/env sh

DOCKER_CLI_EXPERIMENTAL=enabled docker \
  buildx build --platform linux/arm64 \
  -t jbarthel/prysm-beacon-chain:latest-arm64 \
  -f beaconchain.Dockerfile \
  --push \
  .