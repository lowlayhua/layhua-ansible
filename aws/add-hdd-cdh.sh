#!/bin/bash
mkfs -t ext4 /dev/xvdf
mkfs -t ext4 /dev/xvdg
mkdir /data01
mkdir /data02
cp /etc/fstab /etc/fstab.orig
cat << 'EOF' >> /etc/fstab
/dev/xvdf       /data01   ext4    defaults,noatime        1 2
/dev/xvdg       /data02   ext4    defaults,noatime        1 2
EOF
mount -a
