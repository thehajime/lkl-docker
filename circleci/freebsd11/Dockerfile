FROM lkldocker/circleci:0.5
LABEL authors="Hajime Tazaki <thehajime@gmail.com>"

RUN sudo apt-get update && \
    sudo apt-get install -y wget xz-utils qemu-system-x86 p7zip-full build-essential m4 bison flex git vim file libtool automake autoconf autogen pkg-config && \
    sudo rm -rf /var/lib/apt/lists/*

USER ubuntu
WORKDIR /home/ubuntu/

## Note 1: we wanted to use an image from https://download.freebsd.org/ftp/releases/VM-IMAGES/,
## but the image isn't sshd-enabled nor configured so, we tried to use another image,
## from https://github.com/vbkaisetsu/qemu-freebsd-ssh-enabled.
##
## Note 2: but this github image (i.e., https://github.com/vbkaisetsu/qemu-freebsd-ssh-enabled/raw/master/FreeBSD-11.1-RELEASE-amd64.qcow2.xz)
## has quota of git-lfs (can't download more than 1GB in a month?) so, we tentatively use here
## in my local copy.

RUN wget -q http://www.iijlab.net/~tazaki/outgoing/FreeBSD-11.1-RELEASE-amd64.qcow2.xz && \
    unxz FreeBSD-11.1-RELEASE-amd64.qcow2.xz

RUN wget -q http://fossies.org/linux/privat/sshpass-1.06.tar.gz && \
    tar xzf sshpass-1.06.tar.gz && cd sshpass-1.06 && ./configure && make

## Note: building LKL code on qemu (w/o kvm) takes almost forever, around 3hrs in circleci.
## So we build own cross-build chain for FreeBSD.
## cross-build tools
## ref. https://github.com/sandvine/freebsd-cross-build
RUN mkdir -p src
RUN wget -q http://ftp.gnu.org/gnu/binutils/binutils-2.28.1.tar.gz && tar xfz binutils-2.28.1.tar.gz -C src
RUN wget -q http://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz && tar xfJ gmp-6.1.2.tar.xz -C src
RUN wget -q http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.6.tar.xz && tar xfJ mpfr-3.1.6.tar.xz -C src
RUN wget -q http://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz && tar xfz mpc-1.0.3.tar.gz -C src
RUN wget -q http://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.gz && tar xfz gcc-6.4.0.tar.gz -C src

RUN wget -q http://ftp4.us.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/11.1/FreeBSD-11.1-RELEASE-amd64-dvd1.iso && \
    mkdir -p freebsd && \
    (cd freebsd; 7z x ../FreeBSD-11.1-RELEASE-amd64-dvd1.iso usr/include) && \
    (cd freebsd; 7z x ../FreeBSD-11.1-RELEASE-amd64-dvd1.iso usr/lib) && \
    (cd freebsd; 7z x ../FreeBSD-11.1-RELEASE-amd64-dvd1.iso lib) && \
    sudo mv freebsd / && rm -f FreeBSD-11.1-RELEASE-amd64-dvd1.iso
RUN sudo ln -s  /usr/bin/ccache  /usr/lib/ccache/x86_64-pc-freebsd11-gcc

ADD fix-links /freebsd/fix-links

RUN mkdir -p /freebsd/x86_64-pc-freebsd11 && \
    mv /freebsd/usr/include /freebsd/x86_64-pc-freebsd11 && \
    mv /freebsd/usr/lib /freebsd/x86_64-pc-freebsd11 && \
    mv /freebsd/lib/* /freebsd/x86_64-pc-freebsd11/lib && \
    /freebsd/fix-links

RUN cd src/binutils-2.28.1 && \
    ./configure --enable-libssp --enable-ld --target=x86_64-pc-freebsd11 --prefix=/freebsd && \
    make -j4 && \
    make install && \
    cd ~/src/gmp-6.1.2 && \
    ./configure --prefix=/freebsd --enable-shared --enable-static \
      --enable-mpbsd --enable-fft --enable-cxx --host=x86_64-pc-freebsd11 && \
    make -j4 && \
    make install && \
    cd ~/src/mpfr-3.1.6 && \
    ./configure --prefix=/freebsd --with-gnu-ld  --enable-static \
      --enable-shared --with-gmp=/freebsd --host=x86_64-pc-freebsd11 && \
    make -j4 && \
    make install && \
    cd ~/src/mpc-1.0.3/ && \
    ./configure --prefix=/freebsd --with-gnu-ld \
      --enable-static --enable-shared --with-gmp=/freebsd \
      --with-mpfr=/freebsd --host=x86_64-pc-freebsd11  &&\
    make -j4 && \
    make install && \
    mkdir -p ~/src/gcc-6.4.0/build && \
    cd ~/src/gcc-6.4.0/build && \
    ../configure --without-headers --with-gnu-as --with-gnu-ld --disable-nls \
        --enable-languages=c,c++ --enable-libssp --enable-ld \
        --disable-libitm --disable-libquadmath --target=x86_64-pc-freebsd11 \
        --prefix=/freebsd --with-gmp=/freebsd \
        --with-mpc=/freebsd --with-mpfr=/freebsd --disable-libgomp && \
    LD_LIBRARY_PATH=/freebsd/lib make -j10 && \
    make install && \
    cd / && \
    rm -rf ~/src

ENV QEMU "qemu-system-x86_64 -m 2048 \
     -hda FreeBSD-11.1-RELEASE-amd64.qcow2 \
     -netdev user,id=mynet0,hostfwd=tcp:127.0.0.1:7722-:22 \
     -device e1000,netdev=mynet0 -display none -daemonize"

ENV MYSSH "/home/ubuntu/sshpass-1.06/sshpass -p password ssh \
    -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
    -q root@localhost -p7722"

ENV MYSCP "/home/ubuntu/sshpass-1.06/sshpass -p password scp \
    -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -q"


RUN $QEMU && sleep 180 && $MYSSH 'env ASSUME_ALWAYS_YES=YES pkg update' && \
    $MYSSH 'env ASSUME_ALWAYS_YES=YES pkg install gmake binutils git gcc gnubc coreutils argp-standalone fusefs-libs python ccache py27-pip sudo bash' && \
    $MYSSH 'pip install yamlish junit_xml' && \
    $MYSSH 'echo "setenv PATH /usr/local/libexec/ccache:/usr/local/bin:${PATH}" >> /root/.cshrc' && \
    $MYSCP -P 7722 -r root@localhost:/usr/local/include/fuse /freebsd/x86_64-pc-freebsd11/include/ && \
    $MYSCP -P 7722 -r root@localhost:/usr/local/include/fuse.h /freebsd/x86_64-pc-freebsd11/include/ && \
    $MYSCP -P 7722 -r root@localhost:/usr/local/lib/libfuse.so /freebsd/x86_64-pc-freebsd11/lib/ && \
    $MYSCP -P 7722 -r root@localhost:/usr/local/include/argp.h /freebsd/x86_64-pc-freebsd11/include/ && \
    $MYSCP -P 7722 -r root@localhost:/usr/local/lib/libargp.so /freebsd/x86_64-pc-freebsd11/lib/ && \
    $MYSSH 'sync; sync; shutdown -h now' ; sleep 60

ENV PATH /usr/lib/ccache/:/freebsd/bin:${PATH}
