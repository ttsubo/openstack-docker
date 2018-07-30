#!/bin/bash

KEYSTONE_HOST="keystone-server"
NOVA_HOST="nova-server"
HEAT_HOST="heat-server"
GLANCE_HOST="glance-server"
NEUTRON_HOST="neutron-server"
MEMBER_PASSWORD="passw0rd"

mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE keystone;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone';"

/usr/bin/keystone-manage db_sync
sleep 3

# Temporarally start Keystone for us to configure
/usr/bin/keystone-all --config-file=/etc/keystone/keystone.conf --log-file=/var/log/keystone/keystone.log &
sleep 3

# Add domain
openstack domain create --description "Default Domain" default 

# Add keystone service
openstack service create --name keystone --description "keystone user" identity
openstack endpoint create --region RegionOne keystone public "http://${KEYSTONE_HOST}:5000/v3"
openstack endpoint create --region RegionOne keystone internal "http://${KEYSTONE_HOST}:35357/v3"
openstack endpoint create --region RegionOne keystone admin "http://${KEYSTONE_HOST}:35357/v3"

# Create admin project / admin user
openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default --password="${MEMBER_PASSWORD}" admin
openstack role create admin
openstack role add --project admin --user admin admin

# Create demo project / demo user
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password="${MEMBER_PASSWORD}" demo
openstack role create _member_
openstack role add --project demo --user demo _member_
openstack role add --project demo --user admin admin

# Create service project / glance,nova,neutron user
openstack project create --domain default --description "Service Project" service
openstack user create --domain default --password="${MEMBER_PASSWORD}" glance
openstack role add --project service --user glance admin
openstack user create --domain default --password="${MEMBER_PASSWORD}" nova 
openstack role add --project service --user nova admin
openstack user create --domain default --password="${MEMBER_PASSWORD}" neutron
openstack role add --project service --user neutron admin
openstack user create --domain default --password="${MEMBER_PASSWORD}" heat
openstack role add --project service --user heat admin

# Add compute service
openstack service create --name nova --description "OpenStack Nova Service" compute
openstack endpoint create --region RegionOne nova public "http://${NOVA_HOST}:8774/v2/%(tenant_id)s"
openstack endpoint create --region RegionOne nova internal "http://${NOVA_HOST}:8774/v2/%(tenant_id)s"
openstack endpoint create --region RegionOne nova admin "http://${NOVA_HOST}:8774/v2/%(tenant_id)s"

# Add orchestration service
openstack service create --name heat --description "OpenStack Orchestration Service" orchestration
openstack endpoint create --region RegionOne heat public "http://${HEAT_HOST}:8004/v1/%(tenant_id)s"
openstack endpoint create --region RegionOne heat internal "http://${HEAT_HOST}:8004/v1/%(tenant_id)s"
openstack endpoint create --region RegionOne heat admin "http://${HEAT_HOST}:8004/v1/%(tenant_id)s"

# Add image service
openstack service create --name glance --description "OpenStack Image Service" image
openstack endpoint create --region RegionOne glance public "http://${GLANCE_HOST}:9292"
openstack endpoint create --region RegionOne glance internal "http://${GLANCE_HOST}:9292"
openstack endpoint create --region RegionOne glance admin "http://${GLANCE_HOST}:9292"

# Add network service
openstack service create --name neutron --description "OpenStack Network Service" network
openstack endpoint create --region RegionOne neutron public "http://${NEUTRON_HOST}:9696"
openstack endpoint create --region RegionOne neutron internal "http://${NEUTRON_HOST}:9696"
openstack endpoint create --region RegionOne neutron admin "http://${NEUTRON_HOST}:9696"


# kill the keystone
pkill keystone-all
