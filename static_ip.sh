#!/bin/sh

printf '%s' 'IP: '
read IP

if [ "$1" == 'del' ]; then
  sudo ip addr del "$IP/24" dev enp0s25
	exit 0
fi

printf '%s' 'DNS: '
read DNS

sudo ip link set enp0s25 up
sudo ip addr add $IP/24 dev enp0s25
sudo ip route add default via $DNS
echo nameserver $DNS | sudo tee -a /etc/resolv.conf
