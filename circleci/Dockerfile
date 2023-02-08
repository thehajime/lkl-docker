FROM ubuntu:16.04
LABEL authors="Hajime Tazaki <thehajime@gmail.com>, Octavian Purdila <tavi@cs.pub.ro>"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y sudo build-essential bc git xfsprogs ccache btrfs-tools iputils-ping \
                       dosfstools python python-pip python3 python3-pip bison flex && \
    pip  install yamlish==0.18.1 junit_xml==1.9 PyYAML==5.3.1 && \
    pip3 install yamlish==0.18.1 junit_xml==1.9 PyYAML==5.3.1 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash ubuntu && adduser ubuntu sudo && echo -n 'ubuntu:ubuntu' | chpasswd

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu/

ENV PATH /usr/lib/ccache:${PATH}
