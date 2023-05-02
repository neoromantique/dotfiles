#/bin/bash

#stat=$(curl -s "https://corona-stats.online/LT?minimal=true" | head -n 2 | tail -n 1 | awk '{print "SARS-CoV-2: Lithuania Total: " $6 " New: " $8 $9 " Active: " $17}' | sed 's/\x1b\[[0-9;]*m//g' )
stat=$(curl -s "https://corona-stats.online/LT?format=json" | jq '.data[0]' | jq '.cases,  .todayCases, .active' | tr '\r\n' ' ' | awk '{print "🤧:" $2}')

echo "$stat"