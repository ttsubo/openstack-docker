#!/bin/bash
/usr/bin/keystone-all --config-file=/etc/keystone/keystone.conf --log-file=/log/keystone.log
#uwsgi --http 127.0.0.1:35357 --wsgi-file $(which keystone-wsgi-admin)
