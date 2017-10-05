#!/bin/bash

mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE nova;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'nova';"


/usr/bin/nova-manage db sync

# Temporarally start glance for creating glance-image
/usr/bin/nova-api --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-api.log &
/usr/bin/nova-scheduler --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-scheduler.log &
/usr/bin/nova-novncproxy --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-novncproxy.log &
/usr/bin/nova-conductor --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-conductor.log &
/usr/bin/nova-consoleauth --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-consoleauth.log &
/usr/bin/nova-console --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-console.log &
/usr/bin/nova-compute --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-compute.log &
sleep 3

openstack flavor create m1.tiny \
  --id 1 \
  --ram 512 \
  --disk 1 \
  --vcpus 1


pkill nova-api
pkill nova-scheduler
pkill nova-novncproxy
pkill nova-conductor
pkill nova-consoleauth
pkill nova-console
pkill nova-compute
