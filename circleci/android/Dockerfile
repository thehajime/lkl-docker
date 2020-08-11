ARG GIT_ARG
ENV GIT_ARG ${GIT_ARG:-temp}

FROM lkldocker/circleci:$GIT_TAG
LABEL authors="Hajime Tazaki <thehajime@gmail.com>, Octavian Purdila <tavi@cs.pub.ro>"

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && \
    sudo add-apt-repository -y ppa:ts.sch.gr/ppa || true && \
    sudo apt-get update && \
    sudo apt-get install -y --allow-unauthenticated oracle-java8-installer unzip libgl1-mesa-glx libpulse0 && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf /var/cache/oracle-jdk8-installer

# install NDK
RUN wget -q --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-r15b-linux-x86_64.zip && \
    unzip -q android-ndk.zip && \
    rm -f android-ndk.zip

# install SDK
RUN mkdir -p /home/ubuntu/android-sdk && \
    wget -q --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip -q android-sdk.zip -d android-sdk && \
    rm -f android-sdk.zip && \
    echo y | ./android-sdk/tools/bin/sdkmanager emulator "platform-tools" "platforms;android-24"

COPY circle-android.sh /home/ubuntu/

ENV PATH ${PATH}:/home/ubuntu/android-sdk/tools/bin:/home/ubuntu/android-sdk/platform-tools:/home/ubuntu/android-sdk/emulator
