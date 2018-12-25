#!/bin/sh

HOSTNAME=`hostname`
FILE=/home/layhua/system_info.txt

echo "ifconfig -a " >> $FILE
/sbin/ifconfig -a  >> $FILE
echo "" >> $FILE

echo "Server Name" > $FILE
hostname >> $FILE
grep $HOSTNAME /etc/hosts >> $FILE
echo "" >> $FILE

echo "OS Type" >> $FILE
uname -a >> $FILE
echo "" >> $FILE

echo "Running Process: ps auwx " >> $FILE
ps auwwx >> $FILE
echo "" >> $FILE


echo "netstat -a " >> $FILE
netstat -a  >> $FILE
echo "" >> $FILE

echo "pfctl -sr" >> $FILE
pfctl -sr >> $FILE
echo "" >> $FILE

cat /etc/rc.local >> $FILE

cat /etc/rc.conf >> $FILE

