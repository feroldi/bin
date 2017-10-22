#!/bin/sh

printf '%s' 'IP: '
read IP
printf '%s' 'DNS: '
read DNS

sudo ip link set enp0s25 up
sudo ip addr add $IP/24 dev enp0s25
sudo ip route add default via $DNS
echo nameserver $DNS | sudo tee -a /etc/resolv.conf
