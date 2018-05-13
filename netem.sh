#!/bin/bash

if [ "$1" == "add" ]
then
	tc qdisc add dev bond0 root netem delay ${2}ms limit 125000
elif [ "$1" == "del" ]
then
	tc qdisc del dev bond0 root
else
	tc qdisc change dev bond0 root netem delay ${1}ms limit 125000
fi
tc qdisc show dev bond0
