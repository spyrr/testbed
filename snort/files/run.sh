#!/bin/bash
ip link set dev ${NET_IF} promisc on
ethtool -K ${NET_IF} gro off lro off
/snort/bin/snort -D -i ${NET_IF} -c ${SNORT_CONF} -A ${SNORT_OUTMODE} ${SNORT_OPT}
