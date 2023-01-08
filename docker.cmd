Docker

cp -rfv /opt/cardano/cnode/db /opt/cardano/m_core_1a/
cp -rfv /opt/cardano/cnode/db /opt/cardano/m_relay_1a/
cp -rfv /opt/cardano/m_core_1a/db /opt/cardano/cnode/

./node-build.sh m_core_1a mainnet core HodlPool
sudo docker start m_core_1a
sudo docker exec -it m_core_1a /bin/bash
sudo docker exec -it m_core_1a /opt/cardano/cnode/scripts/gLiveView.sh
sudo docker exec m_core_1a /opt/cardano/cnode/scripts/cnode.sh -s
sudo docker stop m_core_1a
sudo docker rm m_core_1a

./node-build.sh m_relay_1a mainnet relay
sudo ./nodes/m_relay_1a
sudo docker exec -it m_relay_1a /bin/bash
sudo docker exec -it m_relay_1a /opt/cardano/cnode/scripts/gLiveView.sh
sudo docker exec m_relay_1a /opt/cardano/cnode/scripts/cnode.sh -s
sudo docker start m_relay_1a
sudo docker stop m_relay_1a
sudo docker rm m_relay_1a


./node-build.sh p_relay_1a preprod
sudo ./nodes/p_relay_1a
sudo docker start p_relay_1a
sudo docker exec -it p_relay_1a /bin/bash
sudo docker exec -it p_relay_1a /opt/cardano/cnode/scripts/gLiveView.sh
sudo docker exec p_relay_1a /opt/cardano/cnode/scripts/cnode.sh -s
sudo docker stop p_relay_1a
sudo docker rm p_relay_1a

./node-build.sh p_core_1a preprod core preprod_hodlr
sudo ./nodes/p_core_1a
sudo docker start p_core_1a
sudo docker exec -it p_core_1a /bin/bash
sudo docker exec -it p_core_1a /opt/cardano/cnode/scripts/gLiveView.sh
sudo docker exec p_core_1a /opt/cardano/cnode/scripts/cnode.sh -s
sudo docker stop p_core_1a
sudo docker rm p_core_1a

cp -rfv /media/dhanz/EXT256/db /opt/cardano/m_relay_2a/ && sudo docker start m_relay_2a
./node-build.sh m_relay_2a mainnet relay
sudo ./nodes/m_relay_2a
sudo docker exec -it m_relay_2a /bin/bash
sudo docker exec -it m_relay_2a /opt/cardano/cnode/scripts/gLiveView.sh
sudo docker exec m_relay_2a /opt/cardano/cnode/scripts/cnode.sh -s
sudo docker start m_relay_2a
sudo docker stop m_relay_2a
sudo docker rm m_relay_2a
sudo docker logs m_relay_2a

./node-build.sh m_stby_2a mainnet relay
sudo ./nodes/m_stby_2a
sudo docker exec -it m_stby_2a /bin/bash
sudo docker exec -it m_stby_2a /opt/cardano/cnode/scripts/gLiveView.sh
sudo docker exec m_stby_2a /opt/cardano/cnode/scripts/cnode.sh -s
sudo docker start m_stby_2a
sudo docker stop m_stby_2a
sudo docker rm m_stby_2a

