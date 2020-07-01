FROM ubuntu:19.10 as og

WORKDIR /opt/wownero

RUN apt-get update && apt-get install -y \
    build-essential cmake pkg-config libboost-all-dev \
    libssl-dev libzmq3-dev libunbound-dev libsodium-dev libpgm-dev git

RUN git clone https://git.wownero.com/wownero/wownero --depth=1 .

RUN make -j2

#

FROM ubuntu:19.10

WORKDIR /data

# Copy static executables and libs from initial container
COPY --from=og /usr/lib/x86_64-linux-gnu/ /usr/lib/x86_64-linux-gnu/
COPY --from=og /opt/wownero/build/Linux/master/release/bin/wownerod /bin/wownerod
COPY --from=og /opt/wownero/build/Linux/master/release/bin/wownero-wallet-cli /bin/wownero-wallet-cli
COPY --from=og /opt/wownero/build/Linux/master/release/bin/wownero-wallet-rpc /bin/wownero-wallet-rpc
