#!/bin/bash

until mysqladmin ping -h mysql-openstack --silent; do
    echo 'waiting for mysqld to be connectable...'
    sleep 3
done

mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE nova_api;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE nova;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE nova_placement;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE nova_cell0;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'nova';"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'nova';"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'nova';"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'nova';"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova_placement.* TO 'nova'@'localhost' IDENTIFIED BY 'nova';"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova_placement.* TO 'nova'@'%' IDENTIFIED BY 'nova';"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'nova';"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'nova';"


/usr/bin/nova-manage api_db sync
/usr/bin/nova-manage db sync

# Temporarally start nova for creating nova-flavor
/usr/bin/nova-api --config-file=/etc/nova/nova.conf --log-file=/log/nova-api.log &
/usr/bin/nova-scheduler --config-file=/etc/nova/nova.conf --log-file=/log/nova-scheduler.log &
/usr/bin/nova-novncproxy --config-file=/etc/nova/nova.conf --log-file=/log/nova-novncproxy.log &
/usr/bin/nova-conductor --config-file=/etc/nova/nova.conf --log-file=/log/nova-conductor.log &
/usr/bin/nova-consoleauth --config-file=/etc/nova/nova.conf --log-file=/log/nova-consoleauth.log &
/usr/bin/nova-console --config-file=/etc/nova/nova.conf --log-file=/log/nova-console.log &
/usr/bin/nova-compute --config-file=/etc/nova/nova.conf --log-file=/log/nova-compute.log &

sleep 20
echo "## Start creating flavor"
openstack flavor create m1.large --id 6 --ram 8192 --disk 80 --vcpus 4 &

sleep 10
echo "## Start creating nova-cell"
/usr/bin/nova-manage api_db sync
/usr/bin/nova-manage cell_v2 map_cell0
/usr/bin/nova-manage cell_v2 create_cell --name=cell1
/usr/bin/nova-manage db sync
/usr/bin/nova-manage cell_v2 list_cells

pkill nova-api
pkill nova-scheduler
pkill nova-novncproxy
pkill nova-conductor
pkill nova-consoleauth
pkill nova-console
pkill nova-compute
pkill openstack

/root/discover.sh &
