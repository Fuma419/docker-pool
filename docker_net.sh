# BEGIN UFW AND DOCKER
*filter
:ufw-user-forward - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j RETURN -s 10.0.0.0/8
-A DOCKER-USER -j RETURN -s 172.16.0.0/12
-A DOCKER-USER -j RETURN -s 192.168.0.0/16

-A DOCKER-USER -j ufw-user-forward

-A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
-A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
-A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
-A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
-A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
-A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

-A DOCKER-USER -j RETURN
COMMIT
# END UFW AND DOCKER


m_core_1a = 172.17.0.2
m_relay_1a = 172.17.0.3
p_relay_1a = 172.17.0.4
p_core_1a = 172.17.0.5

sudo docker container inspect p_relay_1a
sudo ufw route allow 6001
sudo ufw route allow proto tcp from any to $docker_ip port 6000

sudo ufw route allow proto tcp from any to 172.17.0.3 port 8090
sudo ufw route allow proto tcp from any to 172.17.0.3 port 6000
sudo ufw route allow proto tcp from any to 172.17.0.4 port 6000


sudo ufw route allow proto tcp from 3.20.221.145 to 172.17.0.2 port 12798
sudo ufw route allow proto tcp from 3.20.221.145 to 172.17.0.3 port 12798
sudo ufw route allow proto tcp from 3.20.221.145 to 172.17.0.4 port 12798
sudo ufw route allow proto tcp from 3.20.221.145 to 172.17.0.5 port 12798