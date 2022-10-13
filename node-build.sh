#!/bin/bash

###################################
# create the pool #
###################################
NODE_NAME=$1
NETWORK=$2

printf "NODE = $NODE_NAME\n"
printf "NETWORK = $NETWORK\n"

if [ $NETWORK != "mainnet" ] && [ $NETWORK != "preprod" ]; then
    printf "supported networks: preprod | mainnet\n"
    exit 1
fi

./prereqs.sh -f -t $NODE_NAME -n $NETWORK 

cp --no-clobber /opt/cardano/$NODE_NAME/files/topology.json /opt/cardano/$NODE_NAME/files/$NETWORK-topology.json
cp --no-clobber /opt/cardano/$NODE_NAME/files/config.json /opt/cardano/$NODE_NAME/files/$NETWORK-config.json

sudo mkdir nodes

if [ $NETWORK == "preprod" ]; then

    cat > nodes/$NODE_NAME << EOF
    docker run -dit \
    --name $NODE_NAME \
    --security-opt=no-new-privileges \
    -e NETWORK=preprod \
    -e TOPOLOGY="/opt/cardano/cnode/files/$NETWORK-topology.json" \
    -p 3000:6000 \
    -p 12799:12798 \
    -v /opt/cardano/$NODE_NAME/db:/opt/cardano/cnode/db \
    -v /opt/cardano/$NODE_NAME/files:/opt/cardano/cnode/files \
    cardanocommunity/cardano-node
    EOF
fi

if [ $NETWORK == "mainnet" ]; then

cat > ${NODE_NAME} << EOF
docker run -dit \
--name ${NODE_NAME} \
--security-opt=no-new-privileges \
-e NETWORK=preprod \
-e TOPOLOGY="/opt/cardano/cnode/files/${NETWORK}-topology.json" \
-p 6000:6000 \
-p 12798:12798 \
-v /opt/cardano/${NODE_NAME}/db:/opt/cardano/cnode/db \
-v /opt/cardano/${NODE_NAME}/files:/opt/cardano/cnode/files \
cardanocommunity/cardano-node
EOF

fi