#!/bin/bash

###################################
# create the pool #
###################################
NODE_NAME=$1
NETWORK=$2
NODE_TYPE=$3
POOL_NAME=$4

# Set the color variable
green='\033[0;32m'
# Clear the color after that
clear='\033[0m'
printf "${green} ************************************************* ${clear} \n"
printf "*  Name:      ${green} ${NODE_NAME} ${clear} \n"
printf "*  Network:   ${green} ${NETWORK} ${clear}\n"
printf "*  Type:      ${green} ${NODE_TYPE} ${clear}\n"
printf "*  Pool Name: ${green} ${POOL_NAME} ${clear}\n\n"
printf "${green} ************************************************* ${clear} \n"

if [ $NETWORK != "mainnet" ] && [ $NETWORK != "preprod" ]; then
    printf "supported networks: preprod | mainnet\n"
    exit 1
fi


curl -sS -o prereqs.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/prereqs.sh
chmod +x prereqs.sh

./prereqs.sh -f -s -n $NETWORK
./prereqs.sh -f -s -t $NODE_NAME -n $NETWORK

#cp /opt/cardano/cnode/files/topology.json /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json
#cp /opt/cardano/cnode/files/config.json /opt/cardano/$NODE_NAME/files/$NETWORK-config.json

mkdir -pm777 nodes
sudo docker stop $NODE_NAME
sudo docker rm $NODE_NAME

if [ "$NETWORK" == "preprod" ] && [ "$NODE_TYPE" == "core" ]; then

printf "${green}[Info] Creating a preprod core node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--memory=7g \
--cpus=3 \
-e NETWORK=preprod \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e CONFIG="/opt/cardano/cnode/files/$NETWORK-config.json" \
-e POOL_NAME="$POOL_NAME" \
-p 3001:6000 \
-p 12801:12798 \
-e CPU_CORES=2 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
-v /opt/cardano/$NODE_NAME/priv:/opt/cardano/cnode/priv \
-v /opt/cardano/$NODE_NAME/scripts/cnode.sh:/opt/cardano/cnode/scripts/cnode.sh \
cardanocommunity/cardano-node
EOF

mkdir -pm777 /opt/cardano/$NODE_NAME/priv/$POOL_NAME

cp cfg/$NETWORK-topology.json.core /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json
cp cfg/$NETWORK-config.json.core /opt/cardano/$NODE_NAME/files/$NETWORK-config.json

fi

if [ "$NETWORK" == "mainnet" ] && [ "$NODE_TYPE" == "core" ]; then

printf "${green}[Info] Creating a mainnet core node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--memory=30g \
--cpus=5 \
-e NETWORK=mainnet \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e CONFIG="/opt/cardano/cnode/files/$NETWORK-config.json" \
-e POOL_NAME="$POOL_NAME" \
-e CPU_CORES=4 \
-p 6001:6000 \
-p 12800:12798 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
-v /opt/cardano/$NODE_NAME/priv:/opt/cardano/cnode/priv \
-v /opt/cardano/$NODE_NAME/scripts/cnode.sh:/opt/cardano/cnode/scripts/cnode.sh \
cardanocommunity/cardano-node
EOF

mkdir -pm777 /opt/cardano/$NODE_NAME/priv/$POOL_NAME
cp cfg/$NETWORK-topology.json.core /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json
cp cfg/$NETWORK-config.json.core /opt/cardano/$NODE_NAME/files/$NETWORK-config.json

fi

if [ $NETWORK == "preprod" ] && [ "$NODE_TYPE" != "core" ]; then

printf "${green}[Info] Creating preprod relay node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--security-opt=no-new-privileges \
--memory=5g \
--cpus=2 \
-e NETWORK=preprod \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e CONFIG="/opt/cardano/cnode/files/$NETWORK-config.json" \
-e CPU_CORES=2 \
-p 3000:6000 \
-p 12799:12798 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
-v /opt/cardano/$NODE_NAME/scripts/cnode.sh:/opt/cardano/cnode/scripts/cnode.sh \
cardanocommunity/cardano-node
EOF

cp cfg/$NETWORK-topology.json.relay.p2p /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json
cp cfg/$NETWORK-config.json.relay.p2p /opt/cardano/$NODE_NAME/files/$NETWORK-config.json

fi

if [ $NETWORK == "mainnet" ] && [ "$NODE_TYPE" != "core" ]; then

printf "${green}[Info] Creating mainnet relay node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--memory=30g \
--cpus=5 \
-e NETWORK=mainnet \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e CONFIG="/opt/cardano/cnode/files/$NETWORK-config.json" \
-e CPU_CORES=4 \
-e HOSTADDR=0.0.0.0 \
-p 6000:6000 \
-p 12798:12798 \
-p 8090:8090 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
-v /opt/cardano/$NODE_NAME/scripts/cnode.sh:/opt/cardano/cnode/scripts/cnode.sh \
cardanocommunity/cardano-node
EOF

cp cfg/$NETWORK-topology.json.relay.p2p /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json
cp cfg/$NETWORK-config.json.relay.p2p /opt/cardano/$NODE_NAME/files/$NETWORK-config.json

fi


sudo chmod +x nodes/$NODE_NAME
#sudo ./nodes/$NODE_NAME
