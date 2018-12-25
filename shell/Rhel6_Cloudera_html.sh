#!/bin/sh

HOSTNAME=`hostname`
DD=`date +%Y%m%d`
DATE=`date `
mkdir -p /tmp/backup
FILE=DS_$HOSTNAME.$DD.html


echo "<H3>Server Name: $HOSTNAME</H3>" > $FILE
echo "<HR>" >> $FILE
echo "<ol>" >> $FILE

echo "" >> $FILE

echo "<li><B> Hosts File</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v "#"  /etc/hosts >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> OS Type</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
uname -a  >> $FILE
cat /etc/redhat-release >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<li><B> Network Interface</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
/sbin/ifconfig  -a >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "" >> $FILE

echo "<li><B>Network Routing Information</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
netstat -rn >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<li><B>SELINUX</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
getenforce  >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B>/etc/fstab</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
cat /etc/fstab  >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> Disk Partition</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
/sbin/fdisk -l >> $FILE
echo "<P>" >> $FILE
df -h >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE




echo "<BR>" >> $FILE
echo "<li><B> Running Process: ps auwwx </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
ps auwwx >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> Startup Process: chkconfig --list | grep :on  </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
chkconfig --list | grep :on >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE
echo "<BR>" >> $FILE


echo "<li><B> CPU/Swap Information</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
cat /proc/cpuinfo  >> $FILE
free  >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> Firewall Policy Output </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
/sbin/iptables -nL  >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<li><B> NTP status </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
/usr/sbin/ntpq -np >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> Email: Postfix Configuration </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
tail -1 /etc/postfix/main.cf >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B>Cloudera /etc/sysctl.conf Swappiness </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
tail /etc/rc.local >> $FILE
tail /etc/sysctl.conf >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<li><B>Cloudera /etc/rc.local  Disable Redhat Transparent Huge Pages  </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
tail /etc/rc.local >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> Disable  IPv6: /etc/sysconfig/network </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
cat /etc/sysconfig/network >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> java -version </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
java -version 2>> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<HR>" >> $FILE
echo "Generated on $DATE by layhua@singtel.com" >> $FILE
