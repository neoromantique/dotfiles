#!/bin/bash

#SRC: https://github.com/alberto-santini/i3-configuration-x1

~/local/bin/pulseaudio-ctl $1

read -r -a status <<< "$(~/local/bin/pulseaudio-ctl full-status)"
volume=${status[0]}
muted=${status[1]}
bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
icon=""

if [[ $muted = "yes" || $volume = "0" ]]; then
    icon="/usr/share/icons/elementary-xfce-dark/panel/48/audio-volume-muted.png"
elif [[ $volume -lt 35 ]]; then
    icon="/usr/share/icons/elementary-xfce-dark/panel/48/audio-volume-low.png"
elif [[ $volume -lt 70 ]]; then
    icon="/usr/share/icons/elementary-xfce-dark/panel/48/audio-volume-medium.png"
else
    icon="/usr/share/icons/elementary-xfce-dark/panel/48/audio-volume-high.png"
fi

if [[ $muted = "yes" ]]; then
    dunstify -I $icon -r 7414 "    $bar      (muted)"
else
    dunstify -I $icon -r 7414 "    $bar      $volume"
fi
