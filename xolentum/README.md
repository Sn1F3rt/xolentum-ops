# Xolentum

Container image for the official Xolentum source code compiled to provide daemon, wallet CLI, and wallet RPC binaries.

## Pre-requisites:

* Recent Ubuntu Linux
* `sudo apt-get install docker.io docker-compose`
* `sudo usermod -aG docker $(whoami); logout`

## Node-in-a-box

The simplest way to get started is to use docker-compose and turn up the provided packages, including the Xolentum daemon, monitoring tools, and a visualization/graphing tool.

```
cd xolentum/ # in this folder
docker-compose up -d
# xolentumd available at ports 13579 and 13580
```

You can host the node on an official DNS endpoint for public usage or keep it local for your own private usage.

![](files/static/xolentumd-grafana.png)

## Manual Daemon and Wallet Setup

The node and wallet software is in the same package, so both can be used from within the Docker container.

```
# build container image of xolentum binaries
docker build -t xolentum .

# create network bridge so containers can communicate
docker network create --driver=bridge xolentum

# run xolentum daemon with RPC bindings
docker run -d --rm --name xolentum-daemon \
  --net=xolentum \
  -v daemon:/data \
  -p 13580:13580 \
   xolentum \
   xolentumd \
   --data-dir=/data \
   --rpc-bind-ip=0.0.0.0 \
   --confirm-external-bind \
   --non-interactive

# run xolentum-wallet-cli
docker run --rm -it --name xolentum-wallet \
  --net=xolentum \
  -v wallet:/data \
  xolentum \
  xolentum-wallet-cli \
    --trusted-daemon \
    --daemon-address xolentum-daemon:13580
```
