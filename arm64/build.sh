#!/usr/bin/env sh

DOCKER_CLI_EXPERIMENTAL=enabled docker \
  buildx build --platform linux/arm64 \
  -t jbarthel/prysm-node:latest-arm64 \
  -f Dockerfile \
  --push \
  .