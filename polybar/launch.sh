#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

echo "---" | tee -a /tmp/pinkcore.log 
polybar pinkcore 2>&1 | tee -a /tmp/pinkcore.log & disown

echo "Bars launched..."
