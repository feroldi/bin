#!/bin/sh

wpa_supplicant -Dwext -i wlp12s0b1 \
    -c/etc/wpa_supplicant/wpa_supplicant.conf

