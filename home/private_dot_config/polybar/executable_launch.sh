#!/usr/bin/env bash
set -euo pipefail

# Terminate already running bar instances
killall -q polybar || true

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown
