FROM thehajime/circleci:1-intermediate
LABEL authors="Hajime Tazaki <thehajime@gmail.com>, Octavian Purdila <tavi@cs.pub.ro>"

# install toolchain from NDK
RUN ./android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm --api 23 --install-dir ./arm-linux-androideabi && \
    rm -rf android-ndk-r15b

# create emulator image
RUN mkdir -p /home/ubuntu/android-sdk && \
    echo y | ./android-sdk/tools/bin/sdkmanager "system-images;android-24;default;armeabi-v7a" && \
    echo no | ./android-sdk/tools/bin/avdmanager create avd -n Nexus5_API24 -k "system-images;android-24;default;armeabi-v7a"

# create ccache link
RUN cd /usr/lib/ccache && sudo ln -s ../../bin/ccache arm-linux-androideabi-gcc

ENV PATH ${PATH}:/home/ubuntu/arm-linux-androideabi/bin
