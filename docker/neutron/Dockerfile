FROM ubuntu:14.04.5

MAINTAINER Toshiki Tsuboi <t.tsubo2000@gmail.com>

RUN apt-get update \
 && apt-get install -y git python-dev

WORKDIR /
ADD https://bootstrap.pypa.io/get-pip.py /
RUN python get-pip.py

RUN apt-get install -y apt-file \
 && apt-get install -y software-properties-common \
 && apt-get install -y python-software-properties \
 && add-apt-repository -y cloud-archive:mitaka

RUN apt-get update \
 && apt-get install -y neutron-server neutron-plugin-ml2 \
 && apt-get install -y neutron-plugin-linuxbridge-agent \
 && apt-get install -y neutron-l3-agent neutron-dhcp-agent \
 && apt-get install -y neutron-linuxbridge-agent \
 && apt-get install -y python-openstackclient \
 && apt-get install -y rabbitmq-server \
 && apt-get install -y python-mysqldb mysql-client \
 && apt-get install -y python-keystoneclient supervisor \
 && apt-get install -y python-neutronclient bridge-utils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY ./neutron.conf /etc/neutron/neutron.conf
COPY ./init_mitaka.sh /root/init_mitaka.sh
COPY ./openstackrc_admin /root/openstackrc_admin
COPY ./ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
COPY ./linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
COPY ./dhcp_agent.ini /etc/neutron/dhcp_agent.ini
COPY ./l3_agent.ini /etc/neutron/l3_agent.ini
ADD supervisord.conf /etc/supervisor/
ADD rabbitmq.conf /etc/supervisor/conf.d/
ADD neutron-supervisor.conf /etc/supervisor/conf.d

EXPOSE 9696
