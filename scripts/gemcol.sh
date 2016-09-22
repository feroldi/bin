#!/usr/bin/env sh

CPT=0
cat <<EOF
#define fg #d0d0d0
#define bg #000000
#define lbg #020202
*foreground: fg
*background: bg
*cursorColor: #d3d3d3
*color233: bg
*color232: lbg
*color17: #14161b
EOF

while read HEXCODE; do
    printf '*color%d: %s\n' "$CPT" "$HEXCODE"
    CPT=$(expr $CPT + 1)
done | column -t

