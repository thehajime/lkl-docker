FROM ubuntu:16.04
MAINTAINER Hajime Tazaki <thehajime@gmail.com>

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y sudo build-essential bc git xfsprogs ccache btrfs-tools iputils-ping \
                       dosfstools python python-pip && \
    pip install yamlish junit_xml && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash ubuntu && adduser ubuntu sudo && echo -n 'ubuntu:ubuntu' | chpasswd

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu/

ENV PATH ${PATH}:/usr/lib/ccache
