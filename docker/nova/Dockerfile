FROM ubuntu:16.04

MAINTAINER Toshiki Tsuboi <t.tsubo2000@gmail.com>

RUN apt-get update \
 && apt-get install -y git python-dev vim

WORKDIR /
ADD https://bootstrap.pypa.io/get-pip.py /
RUN python get-pip.py \
 && pip install pip==9.0.3

RUN apt-get install -y apt-file \
 && apt-get install -y software-properties-common \
 && apt-get install -y python-software-properties \
 && add-apt-repository -y cloud-archive:queens

RUN apt-get update \
 && apt-get install -y nova-api nova-scheduler \
 && apt-get install -y nova-conductor nova-console \
 && apt-get install -y nova-consoleauth nova-novncproxy \
 && apt-get install -y nova-compute nova-placement-api \
 && apt-get install -y python-openstackclient \
 && apt-get install -y rabbitmq-server \
 && apt-get install -y python-mysqldb mysql-client \
 && apt-get install -y python-keystoneclient supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY ./nova.conf /etc/nova/nova.conf
COPY ./init_queens.sh /root/init_queens.sh
COPY ./openstackrc_admin /root/openstackrc_admin
COPY ./discover.sh /root/discover.sh
ADD supervisord.conf /etc/supervisor/
ADD rabbitmq.conf /etc/supervisor/conf.d/
ADD nova-supervisor.conf /etc/supervisor/conf.d

# Patch for avoiding https://github.com/openstack/nova/commit/c634f78da173423029e9dad5f074619039a4c7bc
COPY ./api.py /usr/lib/python2.7/dist-packages/nova/network/neutronv2/api.py

EXPOSE 5999
EXPOSE 8773
EXPOSE 8774
EXPOSE 8775
