FROM ubuntu:14.04.5
#FROM circleci/build-image:ubuntu-14.04-XXL-1216-11e1e2b
MAINTAINER Hajime Tazaki <thehajime@gmail.com>

RUN apt-get update && apt-get install -y wget software-properties-common apt-transport-https
RUN dpkg --add-architecture i386; echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN wget -q https://dl.winehq.org/wine-builds/Release.key ; apt-key add Release.key ; apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get update && apt-get install -y build-essential bc git libfuse-dev libarchive-dev xfsprogs btrfs-tools dosfstools valgrind ccache gcc-mingw-w64-i686 wine qemu-user-static

RUN cd /usr/lib/ccache && \
	ln -s ../../bin/ccache aarch64-linux-android-gcc && \
	ln -s ../../bin/ccache arm-linux-androideabi-gcc

RUN useradd -ms /bin/bash ubuntu
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu/

RUN wget -q --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-r15b-linux-x86_64.zip && \
	unzip android-ndk.zip && \
	rm -f android-ndk.zip

# arm32
RUN ./android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm --api 23 --install-dir ./arm-linux-androideabi

# patched toolchain https://github.com/lkl/linux/issues/59#issuecomment-187898077
RUN wget -q http://www.iijlab.net/~tazaki/outgoing/gcc-arm-linux-x86_64.tar.bz2 && \
	tar xfj gcc-arm-linux-x86_64.tar.bz2 && \
	 cd arm-linux-androideabi-4.9/ && \
	 ln -s /home/ubuntu/arm-linux-androideabi/sysroot

# arm64
RUN ./android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm64 --api 24 --install-dir ./aarch64-linux-android

# update toolchain https://github.com/lkl/linux/issues/348#issuecomment-312409409
RUN wget -q https://android-git.linaro.org/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-5.4-linaro.git/snapshot/aarch64-linux-android-5.4-linaro-2016.06.tar.gz && \
	 tar xfz aarch64-linux-android-5.4-linaro-2016.06.tar.gz && \
	 cd aarch64-linux-android-5.4-linaro-2016.06 && \
	 ln -s /home/ubuntu/aarch64-linux-android/sysroot

ENV PATH /usr/lib/ccache:${PATH}:/home/ubuntu/aarch64-linux-android-5.4-linaro-2016.06/bin:/home/ubuntu/arm-linux-androideabi-4.9/bin
