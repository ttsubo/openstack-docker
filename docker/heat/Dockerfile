FROM ubuntu:14.04.5
  
MAINTAINER Toshiki Tsuboi <t.tsubo2000@gmail.com>

RUN apt-get update \
 && apt-get install -y git python-dev

WORKDIR /
ADD https://bootstrap.pypa.io/get-pip.py /
RUN python get-pip.py \
 && pip install pip==9.0.3

RUN apt-get install -y apt-file \
 && apt-get install -y software-properties-common \
 && apt-get install -y python-software-properties \
 && add-apt-repository -y cloud-archive:mitaka

RUN apt-get update \
 && apt-get install -y heat-engine \
 && apt-get install -y heat-api \
 && apt-get install -y python-openstackclient \
 && apt-get install -y rabbitmq-server \
 && apt-get install -y python-mysqldb mysql-client \
 && apt-get install -y python-keystoneclient supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY ./heat.conf /etc/heat/heat.conf
COPY ./init_mitaka.sh /root/init_mitaka.sh
COPY ./openstackrc_admin /root/openstackrc_admin
ADD supervisord.conf /etc/supervisor/
ADD rabbitmq.conf /etc/supervisor/conf.d/
ADD heat-supervisor.conf /etc/supervisor/conf.d

ADD versionutils.py /usr/lib/python2.7/dist-packages/oslo_utils/

EXPOSE 8004
