#
lsblk --fs /dev/sdab
lsblk --fs /dev/sdb
vi /etc/fstab

# 

   16  systemctl daemon-reload
   17  mount -a
