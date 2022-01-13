This is a testbed to compose snort/suricata rule.
If you want to develop snort/suricata, then you can, but there is no convinience stuff for developing, vim even.

This container-set consists of as follows:
- Kali - attacker (Kalilinux:kali-rolling)
- Snort (alpine:3.15.0)
- Suricata (Ubuntu:impish-20220105)

You can attach any victim service to testbed network with docker command.

# INSTALL 
## Prerequisite
Create testbed network on docker.
```bash
docker network create --driver=bridge testbed
docker network ls

NETWORK ID     NAME      DRIVER    SCOPE
a5539584c261   bridge    bridge    local
c04e8db9b55d   host      host      local
2fcd6203db84   none      null      local
a6138535ea2d   testbed   bridge    local
```

If we have a plan to sniff testbed network, then NET_IF value must be "br-a6138535ea2d".

```bash
git clone https://github.com/spyrr/testbed.git
cd testbed
NET_IF=br-a6138535ea2d docker-compose up 
```

# Edit local ruleset
```bash
docker-compose exec kali sh
vi /rules/local.rules
```

# reload rules of snort and suricata
## Snort
```bash
docker-compose exec snort sh
kill -1 $(pidof snort)
```

## Suricata
```bash
docker-compose exec suricata sh
/suricata/bin/suricatasc -c ruleset-reload-nonblocking
```

# Run vulnerable server to testbed network
```bash
docker run -it --rm --name victim --net=testbed <some vulnerable image>
```
Run vulnerable container using docker and attack the server from Kali of this container set.
