ARCH="$(uname -m)"

# Download v1.6.0 of the firecracker binary
curl -L https://github.com/firecracker-microvm/firecracker/releases/download/v1.6.0/firecracker-v1.6.0-$ARCH.tgz | tar -xz
mv release-v1.6.0-$ARCH/firecracker-v1.6.0-${ARCH} /tmp/firecracker
rm -rf release-*

# Download a linux kernel binary
wget -O /tmp/kernel.bin https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.8/${ARCH}/vmlinux-5.10.209

# Download a rootfs
wget -O /tmp/rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.8/${ARCH}/ubuntu-22.04.ext4