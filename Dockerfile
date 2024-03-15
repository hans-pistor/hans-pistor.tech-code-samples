FROM alpine

WORKDIR /root

# Set root password
RUN echo "root:root" | chpasswd

# Download dependencies
RUN apk add --update --no-cache \
    openrc \
    util-linux

# Setup login terminal on ttyS0
RUN ln -s agetty /etc/init.d/agetty.ttyS0 \
    && echo ttyS0 > /etc/securetty \
    && rc-update add agetty.ttyS0 default

# Make sure special file systems are mounted on boot
RUN rc-update add devfs boot \
    && rc-update add procfs boot \
    && rc-update add sysfs boot \
    && rc-update add local default


# The /root directory will contain a script that copies
# files from the mounted docker volume into the mounted
# EXT4 file
COPY root /root
COPY etc /etc

RUN rc-update add boot-arg-logger \
    && rc-update add guest-networking