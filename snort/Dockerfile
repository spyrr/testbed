# INSTALLER
FROM alpine:3.15.0 as installer

RUN apk add gcc g++ git autoconf automake libtool linux-headers cmake \
    libdnet-dev flex flex-dev hwloc-dev luajit-dev openssl-dev libpcap-dev \
    pcre-dev libtirpc-dev make

#build libdaq
RUN cd /root && \
    git clone https://github.com/snort3/libdaq.git && \
    cd libdaq && \
    ./bootstrap && \
    ./configure && \
    make -j4 && \
    make install

# build gperf
RUN cd /root && \
    git clone https://github.com/gperftools/gperftools.git && \
    cd gperftools && \
    ./autogen.sh && \
    ./configure && \
    make -j4 && \
    make install

# build snort
RUN cd /root && \
    git clone git://github.com/snortadmin/snort3.git && \
    cd snort3 && \
    ./configure_cmake.sh --prefix=/snort --enable-tcmalloc \
        --enable-hardened-build --enable-pie --disable-docs && \
    cd build && \
    make -j4 && \
    make install

# deploy
#FROM alpine:3.15.0

#RUN mkdir /snort
#WORKDIR /snort
# COPY snort files from installer to deployer
#COPY --from=installer --chown=${USER} /snort .

ENTRYPOINT ["/bin/sh"]
