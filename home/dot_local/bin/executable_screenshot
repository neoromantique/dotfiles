#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%Y-%m-%d_%H-%M-%S_screenshot.png')

gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`
ncolor="-h string:bgcolor:#191724 -h string:fgcolor:#faf4ed -h string:frcolor:#56526e"

if [ "${gtkMode}" == "light" ] ; then
    ncolor="-h string:bgcolor:#f4ede8 -h string:fgcolor:#9893a5 -h string:frcolor:#908caa"
fi

if [ ! -d "$save_dir" ] ; then
    mkdir -p $save_dir
fi

case ${1:-s} in
p)  # Full screen - save and copy
    grim "$save_dir/$save_file"
    wl-copy < "$save_dir/$save_file"
    ;;
s)  # Selection - save and copy
    grim -g "$(slurp)" "$save_dir/$save_file" && wl-copy < "$save_dir/$save_file"
    ;;
e)  # Selection with editor (satty)
    grim -g "$(slurp)" - | satty --filename - --fullscreen --output-filename "$save_dir/satty-$(date '+%Y%m%d-%H%M%S').png"
    ;;
*)  echo "Usage: $0 [p|s|e]"
    echo "  p - full screen"
    echo "  s - selection (default)"
    echo "  e - selection with editor"
    exit 1 ;;
esac

if [ -f "$save_dir/$save_file" ] ; then
    notify-send $ncolor "theme" -a "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi
