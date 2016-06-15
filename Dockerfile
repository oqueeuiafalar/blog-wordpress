FROM ubuntu:16.04
MAINTAINER Tácio Tavares

RUN apt-get update --quiet && \
apt-get upgrade --quiet --assume-yes && \
apt-get install nginx --assume-yes

RUN useradd --create-home --shell /bin/bash natalia
RUN gpasswd -a natalia sudo

USER natalia
WORKDIR /home/natalia

# TODO corrigir problema de permissão no arquivo start_services
ADD ./start_services.sh ./start_services.sh

USER root
CMD ./start_services.sh

EXPOSE 80