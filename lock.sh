#!/bin/bash
scrot -o /tmp/screenshot.png
convert /tmp/screenshot.png -scale 10% -scale 1000% /tmp/screenshotblur.png
i3lock --image /tmp/screenshotblur.png --ignore-empty-password --show-failed-attempts
