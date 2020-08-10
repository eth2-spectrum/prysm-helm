FROM golang:alpine as build
ARG PROCESSNAME
ARG COMMITHASH
ARG HASHDATE
WORKDIR /build
RUN  apk add --update git gcc g++ linux-headers
RUN git clone --shallow-since ${HASHDATE} https://github.com/prysmaticlabs/prysm \
    && cd prysm \
    && git checkout ${COMMITHASH} \
    && rm -rf ./beacon-chain/db/kafka \
    && rm ./beacon-chain/db/db_kafka_wrapped.go \
    && go mod tidy \
    && go install ./{PROCESSNAME}/...

FROM alpine as dist
ARG PROCESSNAME
RUN addgroup -S app && adduser -S app -G app \
    && apk add --update libstdc++ libgcc
COPY --chown=app:app --from=build /go/bin/${PROCESSNAME} /app/${PROCESSNAME}
WORKDIR /app
RUN  echo "#!/usr/bin/env sh"  > run.sh \
    && echo ${PROCESSNAME} '"$@"' >> run.sh \
    && chmod +x run.sh
ENTRYPOINT ["./run.sh"]