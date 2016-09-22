#!/usr/bin/env sh

systemctl "$1" netctl-auto@wlp12s0b1.service
systemctl "$1" netctl-ifplugd@enp9s0.service

systemctl "$2" netctl-auto@wlp8s0b1.service
systemctl "$2" netctl-ifplugd@enp2s0.service

