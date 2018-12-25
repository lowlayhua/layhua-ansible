pvcreate /dev/sdb
vgcreate DBVolGroup /dev/sdb
#lvcreate -l 100%FREE -n data DBVolGroup
#lvcreate -L 10g -n db01 DBVolGroup
#lvcreate -L 10g -n db02 DBVolGroup
#lvcreate -L 90g -n db03 DBVolGroup
#lvcreate -L 180g -n db04 DBVolGroup
#lvcreate -L 180g -n db05 DBVolGroup

mkfs.ext4 /dev/DBVolGroup/db01
mkfs.ext4 /dev/DBVolGroup/db02
mkfs.ext4 /dev/DBVolGroup/db03
mkfs.ext4 /dev/DBVolGroup/db04
mkfs.ext4 /dev/DBVolGroup/db05

mkdir /cci
mkdir /cci/db01
mkdir /cci/db02
mkdir /cci/db03
mkdir /cci/db04
mkdir /cci/db05

cat << 'EOF' >> /etc/fstab
/dev/DBVolGroup/db01 /cci/db01                   ext4    defaults        1 2
/dev/DBVolGroup/db02 /cci/db02                   ext4    defaults        1 2
/dev/DBVolGroup/db03 /cci/db03                   ext4    defaults        1 2
/dev/DBVolGroup/db04 /cci/db04                   ext4    defaults        1 2
/dev/DBVolGroup/db05 /cci/db05                   ext4    defaults        1 2
EOF

