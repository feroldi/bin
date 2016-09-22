#!/usr/bin/env sh

cat $XRES/xres | grep -m1 colors | tail -c+11 | cut -f1 -d'"'

