# API MISC Mainchain - elastos.org
# This is an official but unsupported docker image

FROM golang:1.12-alpine3.10 AS builder

LABEL maintainer="kpachhai"

RUN apk update 
RUN apk add --no-cache curl 
RUN apk add --no-cache make 
RUN apk add --no-cache git
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache linux-headers 

# copy folders
COPY elephant /go/src/github.com/elastos/Elastos.ELA.Elephant.Node

# build env
ENV GOPATH="/go"
ENV GOROOT="/usr/local/go"
ENV GOBIN="$GOPATH/bin"
ENV PATH="$GOROOT/bin:$PATH"
ENV PATH="$GOBIN:$PATH"

# install Glide
RUN curl https://glide.sh/get | sh

# cwd
WORKDIR /go/src/github.com/elastos/Elastos.ELA.Elephant.Node

RUN rm -rf vendor glide.lock 
RUN glide cc
RUN glide update
RUN glide install
RUN make

# alpine3.10
FROM alpine:3.10

ENV SRC_DIR="/elephant"

WORKDIR $SRC_DIR

COPY --from=builder /go/src/github.com/elastos/Elastos.ELA.Elephant.Node/elephant ${SRC_DIR}/elephant

RUN apk update \
    && apk add --no-cache curl ca-certificates \
    && addgroup -g 1000 -S elauser \
    && adduser -h $SRC_DIR -u 1000 -S elauser -G elauser \
    && chown -R elauser:elauser $SRC_DIR
    
USER elauser

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "./elephant"]