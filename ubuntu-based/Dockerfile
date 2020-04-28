FROM ubuntu:18.04
LABEL maintainer="Jaeho Lee <jhlee21071@gmail.com>"

USER root

# 기본 패키지 설치
RUN apt-get update && apt-get -y install \
  nano \
  wget \
  net-tools \
  git \
  openssh-server \
  btrfs-progs \
  e2fsprogs \
  iptables \
  openssl \
  xfsprogs \
  pigz \
  iputils-ping

# docker 설치
RUN apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

ENV DOCKER_VERSION 5:19.03.8~3-0~ubuntu-bionic

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  apt-key fingerprint 0EBFCD88 && \
  add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" && \
  apt-get update && \
  apt-get -y install docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io