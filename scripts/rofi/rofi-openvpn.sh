#!/bin/bash
# Copied from: https://git.john.me.tz/jpm/scripts
# Passwordless sudo required

res=$(echo "SecurEdge|homelab|bohdan|Disconnect|Restart" | rofi -sep "|" -dmenu -i -p 'OpenVPN: ' "" -theme Arc-Dark -columns 9 -width 45 -l 1  -hide-scrollbar -eh 1 -location 0 -auto-select -no-fullscreen)

if [ $res = "SecurEdge" ]; then
    sudo /usr/bin/systemctl stop openvpn@*
    sudo /usr/bin/systemctl start openvpn@SecurEdge
elif [ $res = "homelab" ]; then
    sudo /usr/bin/systemctl stop openvpn@*
    sudo /usr/bin/systemctl start openvpn@homelab
elif [ $res = "bohdan" ]; then
    sudo /usr/bin/systemctl stop openvpn@*
    sudo /usr/bin/systemctl start openvpn@bogdan
elif [ $res = "Disconnect" ]; then
    sudo /usr/bin/systemctl stop openvpn@*
elif [ $res = "Restart" ]; then
    sudo /usr/bin/systemctl restart openvpn@*
fi

if [ "$(pgrep -c i3blocks)" -gt 0 ]; then
    sleep 2s
    pkill -SIGRTMIN+10 i3blocks
    sleep 2s
    pkill -SIGRTMIN+10 i3blocks
fi

exit 0