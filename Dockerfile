FROM ubuntu:16.04
MAINTAINER Tácio Tavares

ENV TERM xterm

# Install packages
RUN apt-get update && \  
    apt-get upgrade --assume-yes && \
    apt-get install nginx --assume-yes && \
    apt-get install sudo --assume-yes && \
    apt-get install nano --assume-yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install mysql-server --assume-yes && \
    apt-get install php-fpm php-mysql --assume-yes

COPY configs/php.ini /etc/php/7.0/fpm/
COPY configs/nginx.conf /etc/nginx/sites-available/default

RUN useradd --create-home --shell /bin/bash natalia
RUN gpasswd -a natalia sudo

USER natalia
WORKDIR /home/natalia

# TODO corrigir problema de permissão no arquivo start_services
ADD ./start_services.sh ./start_services.sh

USER root
CMD ./start_services.sh

EXPOSE 80