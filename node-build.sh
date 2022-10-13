#!/bin/bash

###################################
# create the pool #
###################################
NODE_NAME=$1
NETWORK=$2

printf "NODE = $NODE_NAME"
printf "NETWORK = $NETWORK"

prereqs.sh -t $NODE_NAME -n $NETWORK

cp --no-clobber /opt/cardano/$NODE_NAME/files/topology.json /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json

sudo mkdir nodes

cat > nodes/$NODE_NAME << EOF
docker run -dit \
--name $NODE_NAME \
--security-opt=no-new-privileges \
-e NETWORK=preprod \
-e TOPOLOGY="/opt/cardano/cnode/files/preprod-topology.json" \
-p 3000:6000 \
-p 12799:12798 \
-v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
-v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
cardanocommunity/cardano-node
EOF