FROM debian:stable-slim
WORKDIR /beacon-node
RUN apt update
RUN  apt install -y curl \
    && curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && chmod +x prysm.sh

ENV PATH="/beacon-node:${PATH}"
ENV PRYSM_ALLOW_UNVERIFIED_BINARIES=1
ENTRYPOINT ["prysm.sh", "beacon-chain"]