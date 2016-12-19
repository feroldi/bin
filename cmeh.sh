#!/bin/sh

TMP=/tmp/$(basename "$1")

curl "$1" -o "$TMP" --silent
sxiv "$TMP"
rm "$TMP"

