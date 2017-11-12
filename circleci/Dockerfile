FROM ubuntu:14.04.5
MAINTAINER Hajime Tazaki <thehajime@gmail.com>

RUN useradd -ms /bin/bash ubuntu && adduser ubuntu sudo && echo -n 'ubuntu:ubuntu' | chpasswd

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu/

RUN sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo add-apt-repository ppa:git-core/ppa && \
    sudo apt-get update && \
    sudo apt-get install -y build-essential bc git xfsprogs ccache btrfs-tools dosfstools python && \
    sudo rm -rf /var/lib/apt/lists/*

ENV PATH ${PATH}:/usr/lib/ccache
