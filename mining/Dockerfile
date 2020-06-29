FROM ubuntu:19.10

RUN \
  apt-get update \
  && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev \
  && git clone https://github.com/xmrig/xmrig.git /root/xmrig \
  && mkdir /root/xmrig/build \
  && cd /root/xmrig/build \
  && cmake .. \
  && make

COPY start_mining .

RUN chmod +x start_mining

ENTRYPOINT ["./start_mining"]
