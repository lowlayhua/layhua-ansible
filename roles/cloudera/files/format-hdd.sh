#!/bin/bash
# Written by layhua@singtel.com
# Description: Format disk for DataNode
for x in {d..f}
do
    umount /data/$x
    echo "/dev/sd$x"
    mkfs.ext4 -F /dev/sd$x
    mkdir -p /data/$x

echo    "/dev/sd$x /data/$x                  ext4    defaults,noatime        0"
done
