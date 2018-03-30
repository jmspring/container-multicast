FROM alpine:3.7

MAINTAINER Jim Spring <jmspring@gmail.com>

RUN apk update \ 
    && apk add bash \
    && apk add build-base krb5-libs libtool autoconf automake pkgconf unzip git \
    && cd /tmp \
    && git clone git://github.com/zeromq/libzmq.git \
    && cd libzmq \
    && git checkout d062edd \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && mkdir -p /usr/local/zeromq/perf \
    && cd perf \
    && cp `ls | grep -v "\.o" | grep -v "\.cpp"` /usr/local/zeromq/perf/ \
    && cd \
    && rm -rf /tmp/* \
    && apk del build-base libtool autoconf automake pkgconf unzip git \
    && rm -rf /var/cache/apk/*