#!/bin/bash

###################################
# create the pool #
###################################
NODE_NAME=$1
NETWORK=$2
NODE_TYPE=$3
POOL_NAME=$4

printf "Name: $NODE_NAME\n"
printf "Network: $NETWORK\n\n"
printf "Type: $NODE_TYPE\n\n"
printf "Pool Name: $POOL_NAME\n\n"

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

if [ $NETWORK = "preprod" ]; then

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

if [ $NETWORK = "mainnet" ]; then

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