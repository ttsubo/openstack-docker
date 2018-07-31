FROM ubuntu:16.04

MAINTAINER Toshiki Tsuboi <t.tsubo2000@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git python-dev

WORKDIR /
ADD https://bootstrap.pypa.io/get-pip.py /
RUN python get-pip.py

RUN apt-get install -y apt-file \
 && apt-get install -y software-properties-common \
 && apt-get install -y python-software-properties \
 && add-apt-repository -y cloud-archive:newton

RUN apt-get update \
 && apt-get install -y nova-api nova-scheduler \
 && apt-get install -y nova-conductor nova-console \
 && apt-get install -y nova-consoleauth nova-novncproxy \
 && apt-get install -y nova-compute python-openstackclient \
 && apt-get install -y rabbitmq-server \
 && apt-get install -y python-mysqldb mysql-client \
 && apt-get install -y python-keystoneclient supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY ./nova.conf /etc/nova/nova.conf
COPY ./init_newton.sh /root/init_newton.sh
COPY ./openstackrc_admin /root/openstackrc_admin
ADD supervisord.conf /etc/supervisor/
ADD rabbitmq.conf /etc/supervisor/conf.d/
ADD nova-supervisor.conf /etc/supervisor/conf.d

EXPOSE 5999
EXPOSE 8773
EXPOSE 8774
EXPOSE 8775
