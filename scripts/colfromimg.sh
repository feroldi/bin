#!/usr/bin/env sh
./scripts/colors -ren 16 $1 | ./scripts/gemcol.sh > .xres/colors/$2 && ./scripts/showcol.sh $2
