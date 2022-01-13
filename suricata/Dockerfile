FROM ubuntu:impish-20220105

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y tzdata
RUN apt install -y libpcre3 libpcre3-dbg libpcre3-dev \
        build-essential autoconf automake libtool libpcap-dev libnet1-dev \
        libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev libcap-ng-dev \
        libcap-ng0 make libmagic-dev libjansson-dev rustc cargo jq git-core \
        libpcre2-dev python3-pip

RUN pip install --upgrade pip

ENV PATH="${PATH}:/root/.cargo/bin"
RUN cd /root && \
    cargo install --force cbindgen

RUN cd /root && \
    mkdir suricata && \
    cd suricata && \
    git clone https://github.com/OISF/suricata.git
RUN cd /root/suricata/suricata && \
    git clone https://github.com/OISF/libhtp.git
RUN cd /root/suricata/suricata && \
    ./autogen.sh && \
    ./configure --prefix=/suricata && \
    make && \
    make install-full && \
    ldconfig

RUN cd /root/suricata/suricata && \
    rm -r suricata-update && \
    git clone https://github.com/OISF/suricata-update.git
RUN cd /root/suricata/suricata/suricata-update && \
    python3 setup.py build && \
    python3 setup.py install && \
    suricata-update

#COPY files/local.rules /suricata/etc/suricata/rules/local.rules
COPY files/local.rules /rules/local.rules
RUN ln -s /rules/local.rules /var/lib/suricata/rules/local.rules
RUN ln -s /var/lib/suricata/rules /suricata/etc/suricata/rules
COPY files/run.sh /suricata/run.sh
RUN chmod 700 /suricata/run.sh

RUN sed -i 's/- suricata\.rules/- suricata\.rules\n  - local\.rules/g' \
        /suricata/etc/suricata/suricata.yaml

WORKDIR /suricata

ENV NET_IF='br-a6138535ea2d'

ENTRYPOINT ["/suricata/run.sh"]
