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

printf "Name: ${green} ${NODE_NAME} ${clear} \n"
printf "Network: ${green} ${NETWORK} ${clear}\n"
printf "Type: ${green} ${NODE_TYPE} ${clear}\n"
printf "Pool Name: ${green} ${POOL_NAME} ${clear}\n\n"

if [ $NETWORK != "mainnet" ] && [ $NETWORK != "preprod" ]; then
    printf "supported networks: preprod | mainnet\n"
    exit 1
fi

wget -r https://raw.githubusercontent.com/cardano-community/guild-operators/alpha/scripts/cnode-helper-scripts/prereqs.sh

chmod +x prereqs.sh

./prereqs.sh -f -s -t $NODE_NAME -n $NETWORK 

cp --no-clobber /opt/cardano/$NODE_NAME/files/topology.json /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json
cp --no-clobber /opt/cardano/$NODE_NAME/files/config.json /opt/cardano/$NODE_NAME/files/$NETWORK-config.json

mkdir -pm777 nodes

if [ "$NETWORK" = "preprod" ] && [ "$NODE_TYPE" = "core" ]; then

printf "${green}[Info] Creating a preprod core node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--security-opt=no-new-privileges \
-e NETWORK=preprod \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e POOL_NAME="$POOL_NAME" \
-p 3001:3000 \
-p 12797:12798 \
-e CPU_CORES=4 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
-v /opt/cardano/$NODE_NAME/priv:/opt/cardano/cnode/priv \
cardanocommunity/cardano-node
EOF

mkdir -pm777 /opt/cardano/$NODE_NAME/priv/$POOL_NAME

fi

if [ "$NETWORK" == "mainnet" ] && [ "$NODE_TYPE" == "core" ]; then

printf "${green}[Info] Creating a mainnet core node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--security-opt=no-new-privileges \
-e NETWORK=mainnet \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e CONFIG="/opt/cardano/cnode/files/$NETWORK-config.json" \
-e CUSTOM_PEERS="adaboy-gv9e3q.gleeze.com,3000|adaboy-n28e0q.kozow.com,3000" \
-e POOL_NAME="$POOL_NAME" \
-p 6001:6000 \
-p 12796:12798 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
-v /opt/cardano/$NODE_NAME/priv:/opt/cardano/cnode/priv \
cardanocommunity/cardano-node
EOF

fi

if [ $NETWORK = "preprod" ] && [ "$NODE_TYPE" != "core" ]; then

printf "${green}[Info] Creating preprod relay node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--security-opt=no-new-privileges \
-e NETWORK=preprod \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e CPU_CORES=4 \
-p 3000:3000 \
-p 12799:12798 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
cardanocommunity/cardano-node
EOF

fi

if [ $NETWORK = "mainnet" ] && [ "$NODE_TYPE" != "core" ]; then

printf "${green}[Info] Creating mainnet relay node${clear}\n"

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--security-opt=no-new-privileges \
-e NETWORK=mainnet \
-e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
-e CONFIG="/opt/cardano/cnode/files/$NETWORK-config.json" \
-e CPU_CORES=4 \
-p 6000:6000 \
-p 12798:12798 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
-t \
cardanocommunity/cardano-node
EOF

fi


sudo chmod +x nodes/$NODE_NAME