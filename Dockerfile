FROM golang:1.15-buster AS go-builder
ARG USE_LIBSODIUM=true
ARG USE_LZO=true
ARG GOBIN=/usr/local/bin
RUN apt-get update && \
    apt-get install -y --no-install-recommends liblzo2-dev cmake && \
    go get github.com/wal-g/wal-g || true && \
    cd $GOPATH/src/github.com/wal-g/wal-g && \
    make deps && \
    make pg_build && \
    mv main/pg/wal-g $GOBIN/wal-g

FROM postgres:12
RUN apt-get update && \
    apt-get install -y --no-install-recommends liblzo2-2 libsodium23 ca-certificates
COPY --from=go-builder /usr/local/bin/wal-g /usr/local/bin/wal-g
COPY wal-g /wal-g
