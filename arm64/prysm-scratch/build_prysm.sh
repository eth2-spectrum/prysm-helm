#!/usr/bin/env sh

case $1
in
  "beacon-chain")
    PROCESSNAME=$1;;
  "validator")
    PROCESSNAME=$1;;
  "slasher")
    PROCESSNAME=$1;;
esac

if [ ! "${PROCESSNAME}" ]
then
  echo "Usage: ./build_prysm.sh $0 {beacon-chain|validator|slasher}"
  exit 1
fi

COMMITHASH=${COMMITHASH:-"0d118df0343bf0e268e9fb4f2d5eb60156519c11"}
HASHDATE=${HASHDATE:-"2020-08-01"}
VERSION_TAG=${VERSION_TAG:-"1.0.0-alpha.19"}
DOCKER_REPOSITORY=${DOCKER_REPOSITORY:-"jbarthel"}

DOCKER_CLI_EXPERIMENTAL=enabled docker \
  buildx build --platform linux/arm64 \
  --progress plain \
  --build-arg COMMITHASH=${COMMITHASH} \
  --build-arg HASHDATE=${HASHDATE} \
  --build-arg PROCESSNAME=${PROCESSNAME} \
  -t ${DOCKER_REPOSITORY}/prysm-${PROCESSNAME}-arm64:${VERSION_TAG} \
  -f Dockerfile \
  --push \
  .