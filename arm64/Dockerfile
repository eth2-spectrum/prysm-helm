FROM debian:stable-slim
ARG PROCESS_NAME

WORKDIR /prysm
RUN apt update
RUN apt install -y curl \
    && curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh \
    && chmod +x prysm.sh \
    && adduser --system --group app && chown -R app:app /prysm

ENV PATH="/prysm:${PATH}"
USER app
ENV PRYSM_ALLOW_UNVERIFIED_BINARIES=1
ENTRYPOINT ["prysm.sh"]