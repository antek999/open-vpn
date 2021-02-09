#!/bin/bash   
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw allow 1194/udp
sudo ufw allow OpenSSH
sudo ufw reload
sudo sysctl -p
sudo systemctl -f enable openvpn-server@server.service
sudo systemctl start openvpn-server@server.service
sudo echo "remote $(curl ipinfo.io/ip) 1194" >> /srv/client-configs/base.conf
sudo bash /srv/client-configs/make_config.sh client1 