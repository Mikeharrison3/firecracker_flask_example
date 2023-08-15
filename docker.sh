dd if=/dev/zero of=flask.ext4 bs=1M count=1512

IMG_ID=pythonflask
CONTAINER_ID=$(docker run -td $IMG_ID /bin/bash)
MOUNTDIR=flask
mkdir $MOUNTDIR
IMAGE=flask.ext4
qemu-img create -f raw $IMAGE 1512M
mkfs.ext4 $IMAGE
mount $IMAGE $MOUNTDIR
echo "Copying data"
docker cp $CONTAINER_ID:/ $MOUNTDIR
umount $MOUNTDIR
