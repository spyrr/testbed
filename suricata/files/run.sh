#!/bin/bash

rm /suricata/var/run/suricata.pid
rm /suricata/var/log/suricata/fast.log
/suricata/bin/suricata -D -vvv -c /suricata/etc/suricata/suricata.yaml -i ${NET_IF} --af-packet=${NET_IF}
sleep 5
printf 'tail -F fast.log...\n\n'
exec tail -F /suricata/var/log/suricata/fast.log
