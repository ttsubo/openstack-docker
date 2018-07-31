#!/bin/bash
  
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "CREATE DATABASE heat;"
mysql -uroot -pmysql123 -hmysql-openstack -P3306 -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY 'heat';"


/usr/bin/heat-manage db_sync

pkill heat-api
pkill heat-engine
