#!/bin/bash   
sudo sysctl -p
sudo systemctl -f enable openvpn-server@server.service
sudo systemctl start openvpn-server@server.service
sudo echo "remote $(curl ipinfo.io/ip) 1194" >> /srv/client-configs/base.conf
sudo bash /srv/client-configs/make_config.sh client1 
export X_INTERFACE=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
sudo sed -i 's/XXXXX/'"$X_INTERFACE"'/g' /etc/ufw/before.rules.template
sudo mv /etc/ufw/before.rules.template /etc/ufw/before.rules
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw allow 1194/udp
sudo ufw allow OpenSSH
sudo ufw reload