ARG IMAGE_NAME

FROM $IMAGE_NAME
LABEL authors="Shinichi Awamoto <shinichi.awamoto@gmail.com>"

RUN sudo apt-get update && \
    sudo apt-get install -y cloud-image-utils wget pkg-config\
             libglib2.0-dev libpixman-1-dev linux-image-4.15.0-112-generic&& \
    sudo rm -rf /var/lib/apt/lists/*

RUN sudo cp /boot/vmlinuz-4.15.0-112-generic .
RUN sudo cp /boot/initrd.img-4.15.0-112-generic .

RUN sudo chown ubuntu:ubuntu vmlinuz-4.15.0-112-generic initrd.img-4.15.0-112-generic

RUN wget -O sshpass-1.09.tar.gz -q  https://sourceforge.net/projects/sshpass/files/sshpass/1.09/sshpass-1.09.tar.gz/download && \
    tar xzf sshpass-1.09.tar.gz && cd sshpass-1.09 && ./configure && make

RUN wget https://download.qemu.org/qemu-5.0.0.tar.xz && \
    tar xf qemu-5.0.0.tar.xz && \
    cd qemu-5.0.0 && \
    ./configure --target-list=x86_64-softmmu --disable-numa && \
    make -j8 && \
    sudo make install && \
    cd .. && \
    rm -rf qemu-5.0.0 qemu-5.0.0.tar.xz

RUN wget -q http://cloud-images-archive.ubuntu.com/releases/bionic/release-20200807/ubuntu-18.04-server-cloudimg-amd64.img && \
    qemu-img resize ubuntu-18.04-server-cloudimg-amd64.img 10G

RUN dd if=/dev/zero of=nvme.img bs=1024 count=102400

COPY cloud.txt .
RUN sudo chmod a+r cloud.txt
RUN cloud-localds cloud.img cloud.txt

ENV QEMU "qemu-system-x86_64 -m 2048 -machine q35,kernel-irqchip=split\
     -device intel-iommu,intremap=on -net nic,model=e1000 -net user,hostfwd=tcp::2222-:22\
     -drive file=/home/ubuntu/nvme.img,if=none,id=D22 -device nvme,drive=D22,serial=1234\
     -hda /home/ubuntu/ubuntu-18.04-server-cloudimg-amd64.img -hdb /home/ubuntu/cloud.img\
     -kernel /home/ubuntu/vmlinuz-4.15.0-112-generic\
     -initrd /home/ubuntu/initrd.img-4.15.0-112-generic\
     -append 'root=LABEL=cloudimg-rootfs ro intel_iommu=on console=tty1 console=ttyS0'\
     -display none -serial mon:telnet::5555,server,nowait -daemonize"

ENV MYSSH "/home/ubuntu/sshpass-1.09/sshpass -p lkl ssh \
    -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
    -q lkl@localhost -p2222"

ENV MYSCP "/home/ubuntu/sshpass-1.09/sshpass -p lkl scp \
    -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -q -P 2222"
