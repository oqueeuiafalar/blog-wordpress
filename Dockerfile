FROM ubuntu:16.04
MAINTAINER Tácio Tavares

RUN apt-get update && \
	apt-get install nginx --assume-yes

RUN useradd --create-home --shell /bin/bash natalia
USER natalia
WORKDIR /home/natalia
