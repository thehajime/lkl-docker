FROM i386/ubuntu:18.04
LABEL authors="Hajime Tazaki <thehajime@gmail.com>, Octavian Purdila <tavi@cs.pub.ro>"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y sudo build-essential bc git xfsprogs ccache btrfs-tools iputils-ping \
                       dosfstools python python-pip bison flex iproute2 && \
    pip install yamlish junit_xml && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash ubuntu && adduser ubuntu sudo && echo -n 'ubuntu:ubuntu' | chpasswd

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

ENV PATH /usr/lib/ccache:${PATH}

RUN sudo apt-get update && \
    sudo apt-get install -y libfuse-dev libarchive-dev linux-headers-generic valgrind && \
    sudo rm -rf /var/lib/apt/lists/*


USER ubuntu
WORKDIR /home/ubuntu/
