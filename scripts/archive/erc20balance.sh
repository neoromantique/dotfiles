#/bin/bash

source ~/.secrets/ethplorer.api

#USDT=$(curl -s "https://api.ethplorer.io/getAddressInfo/$ETH_ADDR?apiKey=$ETH_API_KEY" | jq .tokens[0].balance)
USDT=$(curl -s "https://api.ethplorer.io/getAddressInfo/$ETH_ADDR?apiKey=$ETH_API_KEY" | jq -r '(."ETH".balance)*(."ETH"."price"."rate")')

echo ETH=${USDT%.*}$
#echo USDT: $(expr $USDT)$
