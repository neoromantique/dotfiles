#!/bin/bash

# Number of docker containers running
count=$(docker ps -q | wc -l | sed -r 's/^0$//g')

if [ "$count" =  '' ]; then 
    count=0
fi

echo "🐳: $count"


