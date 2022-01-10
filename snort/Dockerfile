# docker run -e NET_IF=br-<network id> snort
FROM alpine:3.15.0

RUN apk add gcc g++ git autoconf automake libtool linux-headers cmake \
    libdnet-dev flex flex-dev hwloc-dev luajit-dev openssl-dev libpcap-dev \
    pcre-dev libtirpc-dev make ethtool

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

# my testbed bridge net interface: br-a6138535ea2d
# NET_INTERFACE = "br-" + DOCKER_NETWORK_ID
ENV NET_IF="docker0"
ENV SNORT_BIN="/snort/bin/snort"
ENV SNORT_CONF="/snort/etc/snort/snort.lua"
ENV SNORT_OUTMODE="alert_fast"
ENV SNORT_OPT="--daq afpacket --daq-var fanout_flag=defrag"
 # DO NOT redefine SNORT_RULE
ENV SNORT_RULE="/snort/local.rules"

WORKDIR /snort

# compose ping alert by default
RUN echo "alert icmp any any <> any any (sid:10000000; msg:'PING...';)" \
        > ${SNORT_RULE}

# include local.rules
RUN sed -i "s/variables = default_variables/include = \('\/snort\/local\.rules'\)/" ${SNORT_CONF}

COPY files/run.sh /snort/run.sh
RUN chmod 700 /snort/run.sh

ENTRYPOINT ["/snort/run.sh"]
