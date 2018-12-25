groupadd -g 1000 oradbs
groupadd -g 1031 dba
useradd -u 1101 -g oradbs -G dba -s /bin/ksh oracle
#mkdir -p /u01/app/11.2.0/grid
mkdir -p /ora01/oracle/admin
chown -R oracle:oradbs /ora01
chmod -R 775 /ora01/
echo "Welcome2014" | passwd --stdin oracle
