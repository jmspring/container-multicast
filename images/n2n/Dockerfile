FROM alpine:3.7

MAINTAINER Jim Spring <jmspring@gmail.com>

RUN apk update \
    && apk add --update openssl \
    && apk add bash coreutils netcat-openbsd \
    && apk add build-base cmake git linux-headers openssl-dev \
    && mkdir -p /tmp/code/src/github.com \
    && cd /tmp/code/src/github.com \
    && git clone https://github.com/meyerd/n2n.git \
    && git clone https://github.com/troglobit/mtools.git \
    && cd n2n/n2n_v2 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install \
    && cd /tmp/code/src/github.com/mtools \
    && make \
    && cp mreceive msend /usr/local/sbin/ \
    && rm -rf /tmp/code \
    && apk del cmake git linux-headers openssl-dev build-base \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /usr/local/n2n

COPY scripts/*.sh /usr/local/n2n/
RUN chmod +x /usr/local/n2n/*.sh