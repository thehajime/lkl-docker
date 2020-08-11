ARG IMAGE_NAME

FROM $IMAGE_NAME
LABEL authors="Hajime Tazaki <thehajime@gmail.com>, Octavian Purdila <tavi@cs.pub.ro>"

# install toolchain from NDK
RUN ./android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm64 --api 23 --install-dir ./aarch64-linux-android && \
    rm -rf android-ndk-r15b

# update toolchain, see https://github.com/lkl/linux/issues/348#issuecomment-312409409
RUN wget -q https://android-git.linaro.org/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-5.4-linaro.git/snapshot/aarch64-linux-android-5.4-linaro-2016.06.tar.gz && \
	 tar xfz aarch64-linux-android-5.4-linaro-2016.06.tar.gz && \
	 cd aarch64-linux-android-5.4-linaro-2016.06 && \
	 ln -s /home/ubuntu/aarch64-linux-android/sysroot && \
	 cd .. && rm -f aarch64-linux-android-5.4-linaro-2016.06.tar.gz

# create emulator image
RUN echo y | ./android-sdk/tools/bin/sdkmanager "system-images;android-24;default;arm64-v8a" && \
    echo no | ./android-sdk/tools/bin/avdmanager create avd -n Nexus5_API24 -k "system-images;android-24;default;arm64-v8a"

# create ccache link
RUN cd /usr/lib/ccache && sudo ln -s ../../bin/ccache aarch64-linux-android-gcc

ENV PATH ${PATH}:/home/ubuntu/aarch64-linux-android-5.4-linaro-2016.06/bin
