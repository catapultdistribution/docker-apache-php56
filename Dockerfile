FROM --platform=linux/x86_64 ubuntu:focal AS maint

ENV UPDATED_AT 10-12-2023

MAINTAINER Ian Warshak <iwarshak@stripey.net>

ARG SKIP_ITMS

RUN apt-get update && apt-get install -y software-properties-common
# add ppa repos
RUN add-apt-repository ppa:ondrej/php
RUN add-apt-repository ppa:ondrej/apache2
RUN add-apt-repository ppa:chris-needham/ppa
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update

# apache & php stuff
RUN apt-get install -y software-properties-common
RUN apt-get install -y php5.6-cli php5.6-fpm php5.6-opcache php5.6-mysql php5.6-curl libapache2-mod-php5.6
RUN apt-get install php5.6-mcrypt php5.6-xml php5.6-mbstring -y

# audio waveform
RUN apt-get install audiowaveform -y

# java stuff
RUN apt-get update && apt-get install -y openjdk-8-jdk
RUN update-alternatives --config java
RUN update-alternatives --config javac
RUN apt-get install --reinstall ca-certificates-java
RUN update-ca-certificates -f

# python stuff
RUN apt-get install -y python3 \
  python3-pip \
  python3-dev \
  python3-setuptools

RUN pip3 install jinja2-cli
RUN pip3 install awscli

# this old aws script
RUN apt-get install -y curl
RUN cd /usr/local/bin; curl https://raw.githubusercontent.com/timkay/aws/master/aws -o aws-timkay && chmod 755 aws-timkay

# apache mods and stuff
RUN a2enmod rewrite
RUN echo export APACHE_RUN_USER=catapult >> /etc/apache2/envvars
RUN echo export APACHE_RUN_GROUP=catapult >> /etc/apache2/envvars
RUN a2enmod remoteip
RUN a2enmod log_forensic

RUN groupadd catapult
RUN useradd -ms /bin/bash -g catapult catapult
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_PID_FILE=/var/run/apache2/apache.pid
ENV APACHE_RUN_USER=catapult
ENV APACHE_RUN_GROUP=catapult
ENV APACHE_LOG_DIR=/var/log/apache2


EXPOSE 80
# end of apache php stuff