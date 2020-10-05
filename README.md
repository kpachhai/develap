## Pre-requisites
- Install Docker Engine
    - [Install Docker Engine for Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
    - [Install Docker Engine for Mac](https://docs.docker.com/docker-for-mac/install/)
    - [Install Docker Engine for Windows](https://docs.docker.com/docker-for-windows/install/)
    - For other platforms, check out [https://docs.docker.com/install/](https://docs.docker.com/install/)
- Golang v1.15 or higher
- Download the latest release specific to your platform from [https://github.com/cyber-republic/develap/releases](https://github.com/cyber-republic/develap/releases)

## URL Routing
- Mainchain Node RPC: 
```
http://localhost:5000/mainnet/blockchain/mainchain
http://localhost:5000/testnet/blockchain/mainchain
```
- DID Node RPC: 
```
http://localhost:5000/mainnet/blockchain/did
http://localhost:5000/testnet/blockchain/did
```
- ETH Node RPC: 
```
http://localhost:5000/mainnet/blockchain/eth
http://localhost:5000/testnet/blockchain/eth
```
- Cross-chain Transfer Service: 
```
http://localhost:5000/mainnet/blockchain/xTransfer
http://localhost:5000/testnet/blockchain/xTransfer
```
- Hive Node: 
```
http://localhost:5000/mainnet/hive
http://localhost:5000/testnet/hive
```

## Available nodes to be setup
1. Mainchain node
    - mainnet: [20334 - RESTAPI Port, 20336 - RPC Port]
    - testnet: [21334 - RESTAPI Port, 21336 - RPC Port]
2. DID node
    - mainnet: [20604 - RESTAPI Port, 20606 - RPC Port]
    - testnet: [21604 - RESTAPI Port, 21606 - RPC Port]
3. Eth node
    - mainnet: [20636 - RPC Port]
    - testnet: [21636 - RPC Port]

## How to Run
- Run a testnet environment with mainchain, did and eth nodes
    `./develap blockchain run -e testnet -n mainchain,did,eth`
- Run a testnet environment with mainchain node
    `./develap blockchain run -e testnet -n mainchain`
- Run a mainnet environment with did node
    `./develap blockchain run -e mainnet -n did`
- Kill eth node on mainnet environment
    `./develap blockchain kill -e mainnet -n eth`
- Kill all the nodes on testnet environment
    `./develap blockchain kill -e testnet`
- Show all the nodes currently running in mainnet environment
    `./develap blockchain list -e mainnet`

## How to build the binary yourself
- `make` to build it for your local environment
- `make build-all` to build for 3 platforms: linux, darwin and windows

## Tools
- [build_dockerimages.sh](./tools/build_dockerimages.sh): This shell script automatically builds all the binaries for main chain, all the sidechains, services, etc and then packages them to be run inside docker images and if the flags "-p" and "-l" are set to "yes", the built docker images are automatically pushed to [Cyber Republic Docker Hub](https://cloud.docker.com/u/cyberrepublic/repository/list). Note that you need permission to push to the CR dockerhub but you can still build the images locally if you so choose
