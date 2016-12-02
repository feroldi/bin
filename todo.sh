#!/bin/sh

ARGS=$@

grep_todo()
{
  grep -rn --color=auto --no-messages \
    --exclude-dir=.git $1 $ARGS
}

count_todos()
{
  local COUNT=$(grep_todo $1 | wc -l)
  [ $COUNT -ne 0 ] && {
    grep_todo $1
    printf '\033[38;5;5m%s\033[0;1;0m\t%s\n' \
      "$1" $COUNT
  }
}

count_todos TODO
count_todos FIXME
count_todos XXX
count_todos HACK

