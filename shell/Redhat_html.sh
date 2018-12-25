#!/bin/sh

HOSTNAME=`hostname`
DD=`date +%Y%m%d`
DATE=`date `
mkdir -p /tmp/backup
FILE=SYS_$DD.$HOSTNAME.html


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

echo "<li><B>Network Socket Information</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
netstat -a >> $FILE
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
echo "<li><B> Password File: /etc/passwd</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
cat /etc/passwd >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<BR>" >> $FILE
CRONUSER=`cd /var/spool/cron; ls *`
for CUSER in ${CRONUSER}; do
echo "<li><B> Cron Job for $CUSER</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
echo "### Start: crontab -l -u $CUSER" >> $FILE
echo "###--------------------------------------------------------" >> $FILE
crontab -l  -u $CUSER >> $FILE
echo "### End: crontab -l  $CUSER" >> $FILE
echo "###--------------------------------------------------------" >> $FILE
echo "" >> $FILE

echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE
done

echo "<li><B> Oracle Cron Job </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
cat /var/spool/cron/crontabs/oracle  >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
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

echo "<li><B> LISTENING PORT </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
netstat -an |  grep LISTEN >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<BR>" >> $FILE
echo "<li><B> ESTABLISHED TCP connection </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
netstat -an |  grep ESTABLISHED |  wc >> $FILE
netstat -an |  grep ESTABLISHED >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE



echo "<li><B> CPU/Swap Information</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
cat /etc/sysconfig/hwconf  >> $FILE
cat /proc/cpuinfo  >> $FILE
swapon -s  >> $FILE
echo "</PRE>" >> $FILE
echo "" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> Firewall Policy Output </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
/sbin/iptables -L  >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<li><B> Installed Perl Modules</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
perldoc perllocal | col -b >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<HR>" >> $FILE
echo "Generated on $DATE by layhua@singtel.com" >> $FILE
