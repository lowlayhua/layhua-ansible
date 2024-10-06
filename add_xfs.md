#
lsblk --fs /dev/sdab
lsblk --fs /dev/sdb
vi /etc/fstab

# 
systemctl daemon-reload
mount -a
