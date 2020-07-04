#!/bin/bash

until mysqladmin ping -h mysql-openstack --silent; do
    echo 'waiting for mysqld to be connectable...'
    sleep 3
done

mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE neutron;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON neutron.* TO 'nova'@'%' IDENTIFIED BY 'neutron';"

/usr/bin/neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head

# Temporarally start neutron for creating network-resource
sleep 10
/usr/bin/neutron-server \
  --config-file=/etc/neutron/neutron.conf \
  --log-file=/log/neutron-server.log &
/usr/bin/neutron-linuxbridge-agent \
  --config-file=/etc/neutron/plugins/ml2/linuxbridge_agent.ini \
  --log-file=/log/neutron-linuxbridge-agent.log &
/usr/bin/neutron-dhcp-agent \
  --config-file=/etc/neutron/dhcp_agent.ini \
  --log-file=/log/neutron-dhcp-agent.log &
/usr/bin/neutron-l3-agent \
  --config-file=/etc/neutron/l3_agent.ini \
  --log-file=/log/neutron-l3-agent.log &
sleep 10

echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf 
echo 'net.ipv4.conf.default.rp_filter=0' >> /etc/sysctl.conf 
echo 'net.ipv4.conf.all.rp_filter=0' >> /etc/sysctl.conf 
sysctl -p 


openstack network create admin_net 
neutron subnet-create admin_net 10.0.0.0/24 --name admin_subnet 
#neutron port-create admin_net 

pkill neutron-server
pkill neutron-linuxbridge-agent
pkill neutron-dhcp-agent
pkill neutron-l3-agent
pkill openstack
pkill neutron
