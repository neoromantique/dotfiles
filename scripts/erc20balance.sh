#/bin/bash

source ~/.secrets/ethplorer.api
USDT=$(curl -s "https://api.ethplorer.io/getAddressInfo/$ETH_ADDR?apiKey=$ETH_API_KEY" | jq .tokens[0].balance)
echo USDT: $(expr $USDT / 1000000)$