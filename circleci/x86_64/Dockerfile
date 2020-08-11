FROM lkldocker/circleci:$GIT_TAG
LABEL authors="Hajime Tazaki <thehajime@gmail.com>, Octavian Purdila <tavi@cs.pub.ro>"

RUN sudo apt-get update && \
    sudo apt-get install -y libfuse-dev libarchive-dev linux-headers-4.4.0-97-generic valgrind libnuma-dev && \
    sudo rm -rf /var/lib/apt/lists/*
