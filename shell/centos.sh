#!/bin/bash
echo ===============================
echo System information and run time
echo ===============================
date
uname -r
ip addr

echo ========================
echo etc fstab
echo ========================
cat /etc/fstab

echo ========================
echo etc modprobe.d CIS.conf
echo ========================
cat /etc/modprobe.d/CIS.conf

echo =================================================
echo etc lsmod - status of modules in the LInux Kernel
echo =================================================
/sbin/lsmod

echo ========================
echo etc yum.conf gpgcheck
echo ========================
grep gpgcheck /etc/yum.conf

echo ==================================
echo querying the installed packages
echo ==================================
rpm -q --queryformat "%{SUMMARY}\n"
rpm -qa --last >~/RPMS_by_Install_Date

echo ========================
echo etc grub.conf
echo ========================
cat /etc/grub.conf

echo ========================
echo etc SELINUX config
echo ========================
grep SELINUX /etc/selinux/config
/usr/sbin/sestatus SELinux

echo ========================
echo list processes running
echo ========================
ps -eZ

echo ========================
echo etc sysconfig init
echo ========================
cat /etc/sysconfig/init

echo ========================
echo Processes config
echo ========================
chkconfig --list

echo ========================
echo etc inittab
echo ========================
cat /etc/inittab

echo ========================
echo etc ntp.conf
echo ========================
cat /etc/ntp.conf

echo ========================
echo netstat
echo ========================
netstat -an

echo ========================
echo list system controls
echo ========================
/sbin/sysctl -a
 
echo ========================
echo list interfaces
echo ========================
ifconfig -a

echo ========================
echo list host configurations
echo ========================
ls -l /etc/hosts.allow
ls -l /etc/hosts.deny
cat /etc/hosts.allow
cat /etc/hosts.deny

echo ========================
echo permission log
echo ========================
ls -l /var/log/

echo ========================
echo Samples of audit log
echo ========================
tail /var/log/auth.log -n 300


echo ========================
echo etc rsyslog.conf
echo ========================
cat /etc/rsyslog.conf

echo ========================
echo etc audit auditd.conf
echo ========================
cat /etc/audit/auditd.conf 

echo ========================
echo etc audit audit.rules
echo ========================
cat /etc/audit/audit.rules

echo ========================
echo etc logrotate.d
echo ========================
grep '{' /etc/logrotate.d/syslog

echo ========================
echo etc cron file permissions
echo ========================
echo -e "\n cron.hourly"
ls -al /etc/cron.hourly
echo -e "\n cron.daily"
ls -al /etc/cron.daily
echo -e "\n cron.weekly"
ls -al /etc/cron.weekly
echo -e "\n cron.d"
ls -al /etc/cron.d
ls -al /etc/at.deny
ls -al /etc/at.allow
ls -al /etc/cron.deny
ls -al /etc/cron.allow
ls -al /etc/ssh/sshd_config

echo ========================
echo etc sshd_Config
echo ========================
cat /etc/ssh/sshd_config

echo ========================
echo etc authconfig
echo ========================
cat /etc/sysconfig/authconfig

echo ========================
echo etc pam.d system-auth
echo ========================
cat /etc/pam.d/system-auth

echo ========================
echo etc pam.d password-auth
echo ========================
cat /etc/pam.d/password-auth 

echo ========================
echo etc securetty
echo ========================
cat /etc/securetty

echo ========================
echo etc pam.d su
echo ========================
cat /etc/pam.d/su

echo ========================
echo etc login.defs
echo ========================
cat /etc/login.defs

echo ========================
echo etc passwd
echo ========================
ls -al /etc/passwd
cat /etc/passwd

echo ========================
echo etc shadow
echo ========================
ls -al /etc/shadow
cat /etc/shadow

echo ========================
echo etc gshadow
echo ========================
ls -al /etc/gshadow
cat /etc/gshadow

echo ========================
echo etc group
echo ========================
ls -al /etc/group
cat /etc/group

echo ========================
echo etc bashrc
echo ========================
cat /etc/bashrc

echo ========================
echo etc profile
echo ========================
cat /etc/profile

echo ========================
echo etc motd
echo ========================
ls -l /etc/motd

echo ========================
echo etc issue
echo ========================
ls -al /etc/issue
cat /etc/issue

df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002

echo $PATH 

for dir in `cat /etc/passwd | awk -F: '{print $6}'`; do echo; echo $dir;ls -dl $dir; ls -al $dir/.*;done;


