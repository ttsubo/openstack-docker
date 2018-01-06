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
 && apt-get install -y glance python-openstackclient \
 && apt-get install -y python-mysqldb mysql-client \
 && apt-get install -y supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY ./glance-api.conf /etc/glance/glance-api.conf
COPY ./glance-registry.conf /etc/glance/glance-registry.conf
COPY ./init_mitaka.sh /root/init_mitaka.sh
COPY ./openstackrc_admin /root/openstackrc_admin
ADD supervisord.conf /etc/supervisor/
ADD glance.conf /etc/supervisor/conf.d/
ADD https://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img /root

EXPOSE 9292
