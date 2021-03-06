# ETH Sidechain - elastos.org
# This is an official but unsupported docker image

FROM golang:1.12-alpine3.10 AS builder

LABEL maintainer="kpachhai"

RUN apk update
RUN apk add --no-cache curl 
RUN apk add --no-cache git
RUN apk add --no-cache make 
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache linux-headers

# copy folders
COPY sidechain.eth /go/src/github.com/elastos/Elastos.ELA.SideChain.ETH

# build env
ENV GOPATH="/go"
ENV GOROOT="/usr/local/go"
ENV GOBIN="$GOPATH/bin"
ENV PATH="$GOROOT/bin:$PATH"
ENV PATH="$GOBIN:$PATH"

# install Glide
RUN curl https://glide.sh/get | sh

# cwd
WORKDIR /go/src/github.com/elastos/Elastos.ELA.SideChain.ETH

# Have to ignore blackfriday package for now. Hopefully this gets changed 
# in the future
RUN printf 'ignore:\n- github.com/russross/blackfriday/v2\n' >> glide.yaml

RUN rm -rf vendor glide.lock 
RUN glide cc
RUN glide update
RUN glide install
RUN make geth

# alpine3.10
FROM alpine:3.10

ENV SRC_DIR="/eth"

WORKDIR $SRC_DIR

COPY --from=builder /go/src/github.com/elastos/Elastos.ELA.SideChain.ETH/build/bin/geth ${SRC_DIR}/geth

RUN apk update \
    && apk add --no-cache curl ca-certificates \
    && addgroup -g 1000 -S elauser \
    && adduser -h $SRC_DIR -u 1000 -S elauser -G elauser \
    && chown -R elauser:elauser $SRC_DIR
    
USER elauser

EXPOSE 8080 20636 20638 20638/udp

ENTRYPOINT ["/bin/sh", "-c", "./geth --mine --datadir elastos_eth --ethash.dagdir elastos_ethash --syncmode 'full' --gcmode 'archive' --rpc --rpcaddr 0.0.0.0 --rpccorsdomain '*' --rpcvhosts '*' --rpcport 20636 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --unlock 0x961386e437294f9171040e2d56d4522c4f55187d --password ./eth-accounts-pass.txt"]