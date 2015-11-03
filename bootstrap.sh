#!/bin/bash
cd ~
curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -M -P git v2015.8.1
sed -i '216i auto_accept: True' /etc/salt/master
#sed -i '227i autosign_file: /etc/salt/autosign.conf' /etc/salt/master
sed -i '16i master: localhost' /etc/salt/minion
sed -i '379i startup_states: highstate' /etc/salt/minion
echo "intern*" > /etc/salt/autosign.conf
echo "ia*" > /etc/salt/autosign.conf
killall salt-minion
killall salt-master
service salt-master restart
service salt-minion restart
