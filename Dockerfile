FROM ubuntu:16.04
MAINTAINER Tácio Tavares
RUN useradd -ms /bin/bash natalia
USER natalia
WORKDIR /home/natalia
# RUN sudo apt-get update && sudo apt-get install nginx