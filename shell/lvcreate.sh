#VolGroup-lv_home
#lvcreate -L 100G -n lv_home VolGroup
#mkfs.ext4 /dev/VolGroup/lv_home
#u01
lvcreate -L 30G -n lv_ora01 VolGroup
mkfs.ext4 /dev/VolGroup/lv_ora01
mkdir /ora01
cat << 'EOF' >> /etc/fstab
/dev/VolGroup/lv_ora01 /ora01                   ext4    defaults        1 2
EOF
mount -a
