FROM debian:stable-slim
WORKDIR /beacon-node
RUN apt update
RUN apt install -y curl \
    && curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && chmod +x prysm.sh \
    && adduser --system --group app && chown -R app:app /beacon-node
USER app

ENV PATH="/beacon-node:${PATH}"
ENV PRYSM_ALLOW_UNVERIFIED_BINARIES=1
ENTRYPOINT ["prysm.sh", "beacon-chain"]