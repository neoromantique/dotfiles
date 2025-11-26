#!/bin/bash
# David Aizenberg
# 2020
# hosts file format, comma separated
# hostname, port, pretty_name, path_to_key user


hostsFile='/home/david/.ssh/ssh.hosts'
lines=20

while read host; do

    if [[ ! ${host:0:1} = \#  ]]; then
        if [ ! -z "$host" ]; then
            hosts+=$(echo $host | awk -F, '{print $3}')'|'
        fi
    fi

done <$hostsFile

res=$(echo "${hosts::-1}" | rofi -sep "|" -dmenu -i -p 'SSH: ' "" -theme Arc-Dark -columns 1 -width 45 -l "$lines"  -hide-scrollbar -eh1 -location 0 -auto-select -no-fullscreen)
if [ ! -z "$res" ]; then
    connectString=$(cat $hostsFile | grep "$res" | awk -F, '{print "ssh " $5 "@" $1 " -p " $2 " -i " $4}')
    xfce4-terminal -e "$connectString"
fi
exit 0