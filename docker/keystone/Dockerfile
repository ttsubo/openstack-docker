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
 && apt-get install -y keystone python-openstackclient \
 && apt-get install -y python-mysqldb mysql-client \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY ./keystone.conf /etc/keystone/keystone.conf
COPY ./init_mitaka.sh /root/init_mitaka.sh
COPY ./start_keystone.sh /root/start_keystone.sh

EXPOSE 5000
EXPOSE 35357
