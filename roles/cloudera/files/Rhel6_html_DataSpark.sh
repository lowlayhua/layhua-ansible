#!/bin/sh

HOSTNAME=`hostname`
DD=`date +%Y%m%d`
DATE=`date `
mkdir -p /tmp/backup
FILE=/tmp/SYSINFO.html


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

echo "<BR>" >> $FILE
echo "<li><B> df -h </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
df -h >> $FILE
echo "</PRE>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B>Network Socket Information</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
netstat -lpn >> $FILE
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
df -h >> $FILE
echo "<P>" >> $FILE
/sbin/fdisk -l >> $FILE
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


echo "<li><B> TCP wrappers configurations: /etc/hosts.allow </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v ^# /etc/hosts.allow >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> TCP wrappers configurations: /etc/hosts.deny </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v ^# /etc/hosts.deny >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> DNS resolv.conf</B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
cat /etc/resolv.conf >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> Access Conf: /etc/security/access.conf </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v ^# /etc/security/access.conf >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<li><B> PAM Configuration: /etc/pam.d/system-auth </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v ^# /etc/pam.d/system-auth >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> PAM Configuration: /etc/pam.d/password-auth </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v ^# /etc/pam.d/password-auth >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> Login Configuration: /etc/login.defs  </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v ^# /etc/login.defs >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> ssh Configuration: /etc/ssh/sshd_config   </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
grep -v ^# /etc/ssh/sshd_config  >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE

echo "<li><B> Software Packages </B>" >> $FILE
echo "<TABLE BORDER=1><TR><TD>" >> $FILE
echo "<PRE>" >> $FILE
rpm -qa >> $FILE
echo "</PRE>" >> $FILE
echo "</ol>" >> $FILE
echo "</TD></TR></TABLE><P>" >> $FILE


echo "<HR>" >> $FILE
echo "Generated on $DATE by layhua@singtel.com" >> $FILE
