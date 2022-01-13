# docker run -e NET_IF=br-<network id> snort
FROM kalilinux/kali-rolling

RUN apt update && \
    apt install -y vim metasploit-framework nmap curl wget net-tools \
        netcat-traditional ncat

WORKDIR /root
COPY files/local.rules /rules/local.rules

ENTRYPOINT ["/bin/bash"]
