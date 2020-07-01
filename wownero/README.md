# Wownero

Container image for the official Wownero source code compiled to provide daemon, wallet CLI, and wallet RPC binaries.

```
# build container image of wownero binaries
docker build -t wownero .

# create network bridge so containers can communicate
docker network create --driver=bridge wownero

# run wownero daemon with RPC bindings
docker run -d --rm --name wownero-daemon \
  --net=wownero \
  -v daemon:/data \
  -p 34568:34568 \
   wownero \
   wownerod \
   --data-dir=/data \
   --rpc-bind-ip=0.0.0.0 \
   --confirm-external-bind \
   --non-interactive

# run wownero-wallet-cli
docker run --rm -it --name wownero-wallet \
  --net=wownero \
  -v wallet:/data \
  wownero \
  wownero-wallet-cli \
    --trusted-daemon \
    --daemon-address wownero-daemon:34568
```
