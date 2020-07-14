ARG DEBIAN_VERSION="${DEBIAN_VERSION:-stable-slim}"
FROM debian:${DEBIAN_VERSION} as wow-dependencies

WORKDIR /data

#Cmake
ARG CMAKE_VERSION=3.14.6
ARG CMAKE_VERSION_DOT=v3.14
ARG CMAKE_HASH=4e8ea11cabe459308671b476469eace1622e770317a15951d7b55a82ccaaccb9
## Boost
ARG BOOST_VERSION=1_70_0
ARG BOOST_VERSION_DOT=1.70.0
ARG BOOST_HASH=430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778

ENV CFLAGS='-fPIC -O2 -g'
ENV CXXFLAGS='-fPIC -O2 -g'
ENV LDFLAGS='-static-libstdc++'

ENV BASE_DIR /usr/local

RUN apt-get update -qq && apt-get --no-install-recommends -yqq install \
        ca-certificates \
        g++ \
        make \
        pkg-config \
        git \
        curl \
        libtool-bin \
        autoconf \
        automake \
        bzip2 \
        xsltproc \
        gperf \
        unzip > /dev/null \
    && cd /data || exit 1 \
    && echo "\e[32mbuilding: Cmake\e[39m" \
    && set -ex \
    && curl -s -O https://cmake.org/files/${CMAKE_VERSION_DOT}/cmake-${CMAKE_VERSION}.tar.gz > /dev/null \
    && echo "${CMAKE_HASH}  cmake-${CMAKE_VERSION}.tar.gz" | sha256sum -c \
    && tar -xzf cmake-${CMAKE_VERSION}.tar.gz > /dev/null \
    && cd cmake-${CMAKE_VERSION} || exit 1 \
    && ./configure --prefix=$BASE_DIR > /dev/null \
    && make > /dev/null \
    && make install > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/cmake-${CMAKE_VERSION} \
    && rm -rf /data/cmake-${CMAKE_VERSION}.tar.gz \
    && echo "\e[32mbuilding: Boost\e[39m" \
    && set -ex \
    && curl -s -L -o  boost_${BOOST_VERSION}.tar.bz2 https://dl.bintray.com/boostorg/release/${BOOST_VERSION_DOT}/source/boost_${BOOST_VERSION}.tar.bz2 > /dev/null \
    && echo "${BOOST_HASH}  boost_${BOOST_VERSION}.tar.bz2" | sha256sum -c \
    && tar -xvf boost_${BOOST_VERSION}.tar.bz2 > /dev/null \
    && cd boost_${BOOST_VERSION} || exit 1 \
    && ./bootstrap.sh > /dev/null \
    && ./b2 -a install --prefix=$BASE_DIR --build-type=minimal link=static runtime-link=static --with-chrono --with-date_time --with-filesystem --with-program_options --with-regex --with-serialization --with-system --with-thread --with-locale threading=multi threadapi=pthread cflags="$CFLAGS" cxxflags="$CXXFLAGS" stage > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/boost_${BOOST_VERSION} \
    && rm -rf /data/boost_${BOOST_VERSION}.tar.bz2

WORKDIR /data
ENV BASE_DIR /usr/local

# OpenSSL
ARG OPENSSL_VERSION=1.1.1
ARG OPENSSL_FIX=g
ARG OPENSSL_HASH=ddb04774f1e32f0c49751e21b67216ac87852ceb056b75209af2443400636d46
# ZMQ
ARG ZMQ_VERSION=v4.3.2
ARG ZMQ_HASH=a84ffa12b2eb3569ced199660bac5ad128bff1f0
# zmq.hpp
ARG CPPZMQ_VERSION=v4.4.1
ARG CPPZMQ_HASH=f5b36e563598d48fcc0d82e589d3596afef945ae
# Readline
ARG READLINE_VERSION=8.0
ARG READLINE_HASH=e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461
# Sodium
ARG SODIUM_VERSION=1.0.18
ARG SODIUM_HASH=4f5e89fa84ce1d178a6765b8b46f2b6f91216677

ENV CFLAGS='-fPIC -O2 -g'
ENV CXXFLAGS='-fPIC -O2 -g'
ENV LDFLAGS='-static-libstdc++'

RUN echo "\e[32mbuilding: Openssl\e[39m" \
    && set -ex \
    && curl -s -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}${OPENSSL_FIX}.tar.gz > /dev/null \
    # && curl -s -O https://www.openssl.org/source/old/${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}${OPENSSL_FIX}.tar.gz > /dev/null \
    && echo "${OPENSSL_HASH}  openssl-${OPENSSL_VERSION}${OPENSSL_FIX}.tar.gz" | sha256sum -c \
    && tar -xzf openssl-${OPENSSL_VERSION}${OPENSSL_FIX}.tar.gz > /dev/null \
    && cd openssl-${OPENSSL_VERSION}${OPENSSL_FIX} || exit 1 \
    && ./Configure --prefix=$BASE_DIR linux-x86_64 no-shared --static "$CFLAGS" > /dev/null \
    && make build_generated > /dev/null \
    && make libcrypto.a > /dev/null \
    && make install > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/openssl-${OPENSSL_VERSION}${OPENSSL_FIX} \
    && rm -rf /data/openssl-${OPENSSL_VERSION}${OPENSSL_FIX}.tar.gz \
    && echo "\e[32mbuilding: ZMQ\e[39m" \
    && set -ex \
    && git clone --branch ${ZMQ_VERSION} --single-branch --depth 1 https://github.com/zeromq/libzmq.git > /dev/null \
    && cd libzmq || exit 1 \
    && test `git rev-parse HEAD` = ${ZMQ_HASH} || exit 1 \
    && ./autogen.sh > /dev/null \
    && ./configure --prefix=$BASE_DIR --enable-libunwind=no --enable-static --disable-shared > /dev/null \
    && make > /dev/null \
    && make install > /dev/null \
    && ldconfig > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/libzmq \
    && echo "\e[32mbuilding: zmq.hpp\e[39m" \
    && set -ex \
    && git clone --branch ${CPPZMQ_VERSION} --single-branch --depth 1 https://github.com/zeromq/cppzmq.git > /dev/null \
    && cd cppzmq || exit 1 \
    && test `git rev-parse HEAD` = ${CPPZMQ_HASH} || exit 1 \
    && mv *.hpp $BASE_DIR/include \
    && cd /data || exit 1 \
    && rm -rf /data/cppzmq \
    && echo "\e[32mbuilding: Readline\e[39m" \
    && set -ex \
    && curl -s -O https://ftp.gnu.org/gnu/readline/readline-${READLINE_VERSION}.tar.gz > /dev/null \
    && echo "${READLINE_HASH}  readline-${READLINE_VERSION}.tar.gz" | sha256sum -c \
    && tar -xzf readline-${READLINE_VERSION}.tar.gz > /dev/null \
    && cd readline-${READLINE_VERSION} || exit 1 \
    && ./configure --prefix=$BASE_DIR > /dev/null \
    && make > /dev/null \
    && make install > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/readline-${READLINE_VERSION} \
    && rm -rf readline-${READLINE_VERSION}.tar.gz \
    && echo "\e[32mbuilding: Sodium\e[39m" \
    && set -ex \
    && git clone --branch ${SODIUM_VERSION} --single-branch --depth 1 https://github.com/jedisct1/libsodium.git > /dev/null \
    && cd libsodium || exit 1 \
    && test `git rev-parse HEAD` = ${SODIUM_HASH} || exit 1 \
    && ./autogen.sh \
    && ./configure --prefix=$BASE_DIR > /dev/null \
    && make > /dev/null \
    && make check > /dev/null \
    && make install > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/libsodium

WORKDIR /data
ENV BASE_DIR /usr/local

# Udev
ARG UDEV_VERSION=v3.2.8
ARG UDEV_HASH=d69f3f28348123ab7fa0ebac63ec2fd16800c5e0
# Libusb
ARG USB_VERSION=v1.0.22
ARG USB_HASH=0034b2afdcdb1614e78edaa2a9e22d5936aeae5d
# Hidapi
ARG HIDAPI_VERSION=hidapi-0.8.0-rc1
ARG HIDAPI_HASH=40cf516139b5b61e30d9403a48db23d8f915f52c
# Protobuf
ARG PROTOBUF_VERSION=v3.7.1
ARG PROTOBUF_HASH=6973c3a5041636c1d8dc5f7f6c8c1f3c15bc63d6

ENV CFLAGS='-fPIC -O2 -g'
ENV CXXFLAGS='-fPIC -O2 -g'
ENV LDFLAGS='-static-libstdc++'

RUN echo "\e[32mbuilding: Udev\e[39m" \
    && set -ex \
    && git clone --branch ${UDEV_VERSION} --single-branch --depth 1 https://github.com/gentoo/eudev > /dev/null \
    && cd eudev || exit 1 \
    && test `git rev-parse HEAD` = ${UDEV_HASH} || exit 1 \
    && ./autogen.sh \
    && ./configure --prefix=$BASE_DIR --disable-gudev --disable-introspection --disable-hwdb --disable-manpages --disable-shared > /dev/null \
    && make > /dev/null \
    && make install > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/eudev \
    && echo "\e[32mbuilding: Libusb\e[39m" \
    && set -ex \
    && git clone --branch ${USB_VERSION} --single-branch --depth 1 https://github.com/libusb/libusb.git > /dev/null \
    && cd libusb || exit 1 \
    && test `git rev-parse HEAD` = ${USB_HASH} || exit 1 \
    && ./autogen.sh > /dev/null \
    && ./configure --prefix=$BASE_DIR --disable-shared > /dev/null \
    && make > /dev/null \
    && make install > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/libusb \
    && echo "\e[32mbuilding: Hidapi\e[39m" \
    && set -ex \
    && git clone --branch ${HIDAPI_VERSION} --single-branch --depth 1 https://github.com/signal11/hidapi > /dev/null \
    && cd hidapi || exit 1 \
    && test `git rev-parse HEAD` = ${HIDAPI_HASH} || exit 1 \
    && ./bootstrap \
    && ./configure --prefix=$BASE_DIR --enable-static --disable-shared > /dev/null \
    && make > /dev/null \
    && make install > /dev/null \
    && cd /data || exit 1 \
    && rm -rf /data/hidapi \
    && echo "\e[32mbuilding: Protobuf\e[39m" \
    && set -ex \
    && git clone --branch ${PROTOBUF_VERSION}  --single-branch --depth 1 https://github.com/protocolbuffers/protobuf > /dev/null \
    && cd protobuf || exit 1 \
    && test `git rev-parse HEAD` = ${PROTOBUF_HASH} || exit 1 \
    && git submodule update --init --recursive > /dev/null \
    && ./autogen.sh > /dev/null \
    && ./configure --prefix=$BASE_DIR --enable-static --disable-shared > /dev/null \
    && make > /dev/null \
    && make install > /dev/null \
    && ldconfig \
    && cd /data || exit 1 \
    && rm -rf /data/protobuf \
    && echo "\e[32mdone building this mofo!\e[39m"
