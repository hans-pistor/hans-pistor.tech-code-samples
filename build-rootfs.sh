set -eu
ROOTFS_FILE=$1
DOCKER_DIRECTORY=$(dirname "$0")
ROOTFS_DIR=/tmp-rootfs
HOST_ROOTFS_DIR=/tmp$ROOTFS_DIR
DOCKER_TAG='rootfs-builder'


# Cleanup from previous attempt
rm -f $ROOTFS_FILE
sudo umount $HOST_ROOTFS_DIR || true
sudo rm -rf $HOST_ROOTFS_DIR

# Create file. You may need to increase the count or blocksize
# if your rootfs get's too big
dd if=/dev/zero of=$ROOTFS_FILE bs=1M count=1024

# Create empty filesystem
sudo mkfs.ext4 $ROOTFS_FILE

# Make sure directory is created
mkdir -p $HOST_ROOTFS_DIR

# Mount the filesystem
sudo mount $ROOTFS_FILE $HOST_ROOTFS_DIR


# Build our custom rootfs builder
docker build --tag $DOCKER_TAG $DOCKER_DIRECTORY

# Runs the container, mounting a volume
docker run -it --rm -v $HOST_ROOTFS_DIR:$ROOTFS_DIR \
    $DOCKER_TAG sh copy-to-rootfs $ROOTFS_DIR

sudo umount $HOST_ROOTFS_DIR