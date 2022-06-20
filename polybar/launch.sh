#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# wait till bars are terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch polybar
polybar mainscreen
