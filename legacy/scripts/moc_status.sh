#!/bin/sh

STATE=$(mocp --format "%state")
MOC="$(mocp --format="%t - %a (%ct/%tt)")"
case $STATE in
    "PLAY")
        COLOR='#00AA00'
        STATUS="▶"
        ;;
    "PAUSE")
        COLOR='#AAAA00'
        STATUS="⏸"
        ;;
    *)
        MOC="Not playing"
        COLOR='#AA0000'
        STATUS=""
        ;;
esac
echo "${STATUS} ${MOC}"
echo "${STATUS} ${MOC}"
echo "$COLOR"
