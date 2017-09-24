FROM ubuntu:14.04.5
MAINTAINER Hajime Tazaki <thehajime@gmail.com>

# preparation for later apt-get
RUN apt-get update && apt-get install -y wget software-properties-common apt-transport-https
RUN dpkg --add-architecture i386; echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections &&  wget -q https://dl.winehq.org/wine-builds/Release.key ; apt-key add Release.key ; apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'

# java8 for android sdk
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  add-apt-repository ppa:git-core/ppa && \
  apt-get update && \
  apt-get install -y build-essential bc git libfuse-dev libarchive-dev xfsprogs valgrind linux-headers-$(uname -r) ccache gcc-mingw-w64-i686 wine qemu-user-static oracle-java8-installer btrfs-tools dosfstools git && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

RUN cd /usr/lib/ccache && \
	ln -s ../../bin/ccache aarch64-linux-android-gcc && \
	ln -s ../../bin/ccache arm-linux-androideabi-gcc

RUN useradd -ms /bin/bash ubuntu && adduser ubuntu sudo && echo -n 'ubuntu:ubuntu' | chpasswd

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu/

# android setup
RUN wget -q --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-r15b-linux-x86_64.zip && \
	unzip -q android-ndk.zip && \
	rm -f android-ndk.zip

RUN mkdir -p /home/ubuntu/android-sdk && \
    wget -q --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip -q android-sdk.zip -d android-sdk && \
    rm -f android-sdk.zip

RUN echo y | ./android-sdk/tools/bin/sdkmanager emulator "system-images;android-24;default;armeabi-v7a" \
   "system-images;android-24;default;arm64-v8a" "platform-tools" "platforms;android-24"
RUN echo no | ./android-sdk/tools/bin/avdmanager create avd -n Nexus5_API24 -k "system-images;android-24;default;armeabi-v7a"
RUN echo no | ./android-sdk/tools/bin/avdmanager create avd -n Nexus5X_API24 -k "system-images;android-24;default;arm64-v8a"


# arm32
RUN ./android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm --api 23 --install-dir ./arm-linux-androideabi

# arm64
RUN ./android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm64 --api 23 --install-dir ./aarch64-linux-android

# update toolchain https://github.com/lkl/linux/issues/348#issuecomment-312409409
RUN wget -q https://android-git.linaro.org/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-5.4-linaro.git/snapshot/aarch64-linux-android-5.4-linaro-2016.06.tar.gz && \
	 tar xfz aarch64-linux-android-5.4-linaro-2016.06.tar.gz && \
	 cd aarch64-linux-android-5.4-linaro-2016.06 && \
	 ln -s /home/ubuntu/aarch64-linux-android/sysroot && \
	 cd .. && rm -f aarch64-linux-android-5.4-linaro-2016.06.tar.gz

# checkout lkl code (XXX: no space left with this line)
# RUN mkdir -p /home/ubuntu/project &&  cd /home/ubuntu/project && git clone https://github.com/lkl/linux .

COPY circle-android.sh /home/ubuntu/

ENV PATH /usr/lib/ccache:/home/ubuntu/aarch64-linux-android-5.4-linaro-2016.06/bin:/home/ubuntu/arm-linux-androideabi/bin:/home/ubuntu/android-sdk/tools/bin:/home/ubuntu/android-sdk/platform-tools:/home/ubuntu/android-sdk/emulator:${PATH}
