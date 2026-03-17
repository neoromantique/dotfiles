complete -c tt -f -k -a "(ls -1dt ~/tmp/*/ 2>/dev/null | string replace -r '.*/(.+)/' '\$1')"
