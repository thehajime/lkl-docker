FROM lkldocker/circleci:0.2
MAINTAINER Hajime Tazaki <thehajime@gmail.com>

RUN sudo apt-get update && sudo apt-get install -y wget apt-transport-https

RUN sudo dpkg --add-architecture i386 && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections && \
    wget -q https://dl.winehq.org/wine-builds/Release.key -O - | sudo apt-key add - && \
    sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'

RUN sudo apt-get update && \
    sudo apt-get install -y gcc-mingw-w64-i686 wine && \
    sudo rm -rf /var/lib/apt/lists/*
