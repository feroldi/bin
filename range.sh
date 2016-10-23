#!/bin/sh

usage () {
	echo "usage: $0 FIRST LAST"
	echo "   or: $0 FIRST INCREASE LAST"
	echo "   or: $0 LAST"
	exit 1
}

[ $# -eq 0 ] && usage

# defaults
MIN=1
INC=1

# set arguments
[ $# -gt 2 ] && INC=$2
[ $# -gt 1 ] && MIN=$1
[ $# -gt 0 ] && MAX=$(echo $@ | cut -d' ' -f $#)

# loop
awk -v S=$MIN -v E=$MAX -v I=$INC \
	'BEGIN { for (i=S; i <= E; i=i+I) printf "%d\n", i; }'
