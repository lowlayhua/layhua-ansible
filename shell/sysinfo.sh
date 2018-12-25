#!/bin/sh

HOSTNAME=`hostname`
DD=`date +%Y%m%d`
DATE=`date `
mkdir -p /tmp/backup
FILE=/tmp/backup/SYS_$DD.$HOSTNAME.html


echo "<H3>Server Name: $HOSTNAME</H3>" > $FILE
echo "<HR>" >> $FILE
echo "<ol>" >> $FILE

echo "" >> $FILE

echo "<li><B> Hosts File</B>" >> $FILE
echo "<PRE>" >> $FILE
grep -v "#"  /etc/hosts >> $FILE
echo "</PRE>" >> $FILE

echo "<li><B> OS Type</B>" >> $FILE
echo "<PRE>" >> $FILE
uname -a  >> $FILE
echo "</PRE>" >> $FILE


echo "<li><B> Network Interface</B>" >> $FILE
echo "<PRE>" >> $FILE
/usr/sbin/ifconfig  -a >> $FILE
echo "</PRE>" >> $FILE

echo "" >> $FILE

echo "<li><B>Network Routing Information</B>" >> $FILE
echo "<PRE>" >> $FILE
netstat -rn >> $FILE
echo "</PRE>" >> $FILE

echo "<li><B>Network Socket Information</B>" >> $FILE
echo "<PRE>" >> $FILE
netstat -a >> $FILE
echo "</PRE>" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> Disk Partition</B>" >> $FILE
echo "<PRE>" >> $FILE
df -h >> $FILE
echo "</PRE>" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> Disk Format</B>" >> $FILE
echo "<PRE>" >> $FILE
echo | format >> $FILE
echo "</PRE>" >> $FILE

echo "<PRE>" >> $FILE
echo "<li><B> Disk File: /etc/mnttab</B>" >> $FILE
cat /etc/mnttab >> $FILE
echo "</PRE>" >> $FILE

echo "<PRE>" >> $FILE
echo "<li><B> Disk File: /etc/fstab</B>" >> $FILE
cat /etc/vfstab >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> Root Cron Job </B>" >> $FILE
echo "<PRE>" >> $FILE
cat /var/spool/cron/crontabs/root  >> $FILE
echo "</PRE>" >> $FILE

echo "<li><B> Oracle Cron Job </B>" >> $FILE
echo "<PRE>" >> $FILE
cat /var/spool/cron/crontabs/oracle  >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> Running Process: /usr/ucb/ps axuwww </B>" >> $FILE
echo "<PRE>" >> $FILE
/usr/ucb/ps axuwww >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> Running Process: ptree </B>" >> $FILE
echo "<PRE>" >> $FILE
ptree >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
echo "<BR>" >> $FILE
echo "<li><B> LISTENING PORT </B>" >> $FILE
echo "<PRE>" >> $FILE
netstat -an |  grep LISTEN >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> ESTABLISHED TCP connection </B>" >> $FILE
echo "<PRE>" >> $FILE
netstat -an |  grep ESTABLISHED |  wc >> $FILE
netstat -an |  grep ESTABLISHED >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE



echo "<li><B> Machine Type</B>" >> $FILE
echo "<PRE>" >> $FILE
/usr/sbin/prtconf  >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE

echo "<li><B> Display kernel statistics</B>" >> $FILE
echo "<PRE>" >> $FILE
/usr/bin/kstat  >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE


echo "<HR>" >> $FILE
echo "Generated on $DATE" >> $FILE

