#!/bin/bash

until mysqladmin ping -h mysql-openstack --silent; do
    echo 'waiting for mysqld to be connectable...'
    sleep 3
done

mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE glance;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'glance';"

/usr/bin/glance-manage db_sync

# Temporarally start glance for creating glance-image
/usr/bin/glance-api --config-file=/etc/glance/glance-api.conf --log-file=/var/log/glance/glance-api.log &
/usr/bin/glance-registry --config-file=/etc/glance/glance-registry.conf --log-file=/var/log/glance/glance-registry.log &
sleep 3

openstack image create "cirros" \
  --file cirros-0.3.5-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public

pkill glance-api
pkill glance-registry
