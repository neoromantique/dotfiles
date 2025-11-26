#!/bin/bash
# Helper script for vpn-switcher to run privileged commands
# This gets called via pkexec

ACTION="$1"
shift

case "$ACTION" in
    wg-up)
        wg-quick up "$1"
        ;;
    wg-down)
        wg-quick down "$1"
        ;;
    systemctl-start)
        systemctl start "$1"
        ;;
    *)
        echo "Unknown action: $ACTION" >&2
        exit 1
        ;;
esac
