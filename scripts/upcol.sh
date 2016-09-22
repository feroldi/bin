#!/usr/bin/env sh

i3_base="$HOME/.i3/base"

rm $i3_base $xres_base

curr_color_dir=$(cat .xres/xres | grep '#include "colors' | sed 's/#include[ ]*"\(.*\)"/\1/')
defs=$(cat ".xres/$curr_color_dir" | grep '#define')

echo $defs | while read color; do
    if [ -n $color ]; then
        color=$(echo $color | sed 's/#define[ ]*//')
        echo "set \$$color" >> $i3_base
    fi
done
