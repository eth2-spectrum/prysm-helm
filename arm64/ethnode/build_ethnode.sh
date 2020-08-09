#!/usr/bin/env sh

if [ -d tmp ]
then
  rm -rf tmp
fi

mkdir tmp
cd tmp

git clone --shallow-since 2020-07-25 https://github.com/ethereum/go-ethereum.git
cd go-ethereum
git checkout v1.9.18

DOCKER_CLI_EXPERIMENTAL=enabled docker \
  buildx build --platform linux/arm64 \
  -t jbarthel/go-ethereum:v1.9.18-arm64 \
  -f Dockerfile \
  --push \
  .

cd ../..