# INSTALL 
## Prerequisite
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
