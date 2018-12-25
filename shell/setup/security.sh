#!/bin/bash
echo "Running post-install script for SingTel"
echo "Modify fstab"
sed -i'' -e 's/shm.*tmpfs.*defaults/shm tmpfs defaults,nodev,nosuid,noexec/g' /etc/fstab
echo "/var/tmp		/tmp			none	bind		0 0" >> /etc/fstab

echo "Set Sticky Bit on All World-Writable Directories"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -print0 -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs -0 chmod a+t 

echo "Block unneeded modules"
echo "install cramfs /bin/true" > /etc/modprobe.d/CIS.conf
echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf

echo "Verify that gpgcheck is Globally Activated"
sed -i'' -e 's/gpgcheck=0/gpgcheck=1/g' /etc/yum.conf

echo "Disable the rhnsd Daemon"
chkconfig rhnsd off

echo "Init AIDE"
aide -i -B 'database_out=file:/var/lib/aide/aide.db.gz'
aide —check
prelink --all

echo "Implement Periodic Execution of File Integrity"
echo "0 5 * * * /usr/sbin/aide —check" >> /etc/crontab

echo "Set Permissions on /etc/grub.conf"
chmod og-rwx /etc/grub.conf

echo "Require Authentication for Single-User Mode & Disable Interactive Boot"
sed -i "/SINGLE/s/sushell/sulogin/" /etc/sysconfig/init
sed -i "/PROMPT/s/yes/no/" /etc/sysconfig/init

echo "Additional Process Hardening"
echo "* hard core 0" >> /etc/security/limits.conf
echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
echo "kernel.exec-shield = 1" >> /etc/sysctl.conf
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf

echo "Remove unnecessary services"
yum -q -y erase telnet-server  telnet rsh-server rsh ypbind ypserv tftp tftp-server talk talk-server xinetd dhcp
chkconfig chargen-dgram off
chkconfig chargen-stream off
chkconfig daytime-dgram off
chkconfig chargen-stream off
chkconfig daytime-dgram off
chkconfig daytime-stream off
chkconfig echo-dgram off
chkconfig echo-stream off
chkconfig tcpmux-server off
chkconfig avahi-daemon off
chkconfig cups off

echo "Set Daemon umask"
echo "umask 027" >> /etc/sysconfig/init

echo "Disable IP Forwarding"
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf

echo "Disable Send Packet Redirects"
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf

echo "Disable Source Routed Packet Acceptance"
echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf

echo "Disable ICMP Redirect Acceptance"
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf 

echo "Disable Secure ICMP Redirect Acceptance"
echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.conf

echo "Log Suspicious Packets"
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.conf

echo "Enable Ignore Broadcast Requests"
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf

echo "Enable Bad Error Message Protection"
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf

echo "Enable RFC-recommended Source Route Validation"
echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=1" >> /etc/sysctl.conf

echo "Enable TCP SYN Cookies"
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf

echo "Disable IPv6 RA"
echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.conf

echo "Disable IPv6 Redirect Acceptance"
echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.conf 
echo "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.conf

echo "Disable IPv6"
echo "NETWORKING_IPV6=no" >> /etc/sysconfig/network
echo "IPV6INIT=no" >> /etc/sysconfig/network
echo "options ipv6 disable=1" > /etc/modprobe.d/ipv6.conf
chkconfig ip6tables off

echo "Disable Uncommon Network Protocols"
echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf

echo "Disable IPtables"
chkconfig iptables off

echo "Keep All Auditing Information"
sed -i'' -e 's/ROTATE/keep_logs/g' /etc/audit/auditd.conf

echo "Enable Auditing for Processes That Start Prior to auditd"
ed /etc/grub.conf << END
g/audit=1/s///g
g/kernel/s/$/ audit=1/
w
q 
END

echo "Configure Auditd Events"
cat >> /etc/audit/audit.rules << EOF
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
-w /etc/selinux/ -p wa -k MAC-policy
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /var/log/tallylog -p wa -k logins
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-w /etc/sudoers -p wa -k scope
-w /var/log/sudo.log -p wa -k actions
-w /sbin/insmod -p x -k modules -w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module -S delete_module -k modules
-e 2
# following lines generated with:
# find PART -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print ”-a always,exit -F path=" $1 " -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged" }'
-a always,exit -F path=/bin/ping -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/bin/su -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/bin/ping6 -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/bin/umount -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/bin/mount -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/bin/cgexec -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/sbin/pam_timestamp_check -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/sbin/unix_chkpwd -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/sbin/netreport -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/sbin/mount.nfs -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/pkexec -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/at -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/chage -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/ssh-agent -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/chsh -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/ksu -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/passwd -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/write -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/locate -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/staprun -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/newgrp -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/chfn -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/wall -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/gpasswd -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/crontab -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/libexec/abrt-action-install-debuginfo-to-abrt-cache -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/libexec/polkit-1/polkit-agent-helper-1 -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/libexec/utempter/utempter -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/libexec/pt_chown -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/libexec/openssh/ssh-keysign -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/sbin/userhelper -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/sbin/postdrop -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/sbin/postqueue -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/sbin/usernetctl -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged
-a always,exit -F path=/lib64/dbus-1/dbus-daemon-launch-helper -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged

EOF

echo "Configure logrotate"
sed -i '1i /var/log/boot.log' /etc/logrotate.d/syslog 
sed -i '1i /var/log/cron' /etc/logrotate.d/syslog

echo "Set User/Group Owner and Permission on /etc/anacrontab"
chown root:root /etc/anacrontab
chmod og-rwx /etc/anacrontab

echo "Set User/Group Owner and Permission on /etc/crontab"
chown -R root:root /etc/cron*
chmod -R og-rwx /etc/cron*

echo "Restrict at/cron Daemon" 
rm /etc/at.deny
touch /etc/at.allow
chown root:root /etc/at.allow
chmod og-rwx /etc/at.allow
rm /etc/cron.deny
touch /etc/cron.allow
chown root:root /etc/cron.allow
chmod og-rwx /etc/cron.allow
echo "root" > /etc/cron.allow
echo "root" > /etc/at.allow

echo "Configure SSH"
groupadd ssh
adduser appadm -G ssh
adduser hpbac -G ssh
adduser layhua -G ssh
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config
echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config
sed -i'' -e 's/^X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
echo "IgnoreRhosts yes" >> /etc/ssh/sshd_confg
echo "Hostbasedauthentication no" >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/sshd_config
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config
##echo "AllowGroups ssh" >> /etc/ssh/sshd_config
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config

echo "Set Password Creation Requirement Parameters Using pam_cracklib"
sed -i'' -e 's/retry=3 type=/retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1/g' /etc/pam.d/system-auth

echo "Set Lockout for Failed Password Attempts"
sed -i'' -e 's/pam_env.so$/pam_env.so\nauth required pam_faillock.so preauth audit silent deny=5 unlock_time=900/g' /etc/pam.d/password-auth
sed -i'' -e 's/^auth.*sufficient.*pam_unix.so.*$/auth \[success=1 default=bad\] pam_unix.so\nauth \[default=die\] pam_faillock.so authfail audit deny=5 unlock_time=900\nauth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900/g' /etc/pam.d/password-auth
sed -i'' -e '/^auth.*requisite.*pam_succeed_if.so.*uid.*500.*quiet$/d' /etc/pam.d/password-auth
sed -i'' -e 's/pam_env.so$/pam_env.so\nauth required pam_faillock.so preauth audit silent deny=5 unlock_time=900/g' /etc/pam.d/system-auth
sed -i'' -e 's/^auth.*sufficient.*pam_unix.so.*$/auth \[success=1 default=bad\] pam_unix.so\nauth \[default=die\] pam_faillock.so authfail audit deny=5 unlock_time=900\nauth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900/g' /etc/pam.d/system-auth
sed -i'' -e '/^auth.*requisite.*pam_succeed_if.so.*uid.*500.*quiet$/d' /etc/pam.d/system-auth

echo "Limit Password Reuse"
sed -i'' -e 's/^password.*sufficient.*pam_unix.so/password sufficient pam_unix.so remember=5/g'

echo "Restrict Access to the su Command"
sed -i'' -e '/#auth.*required.*pam_wheel.so use_uid/auth required pam_wheel.so use_uid/g' /etc/pam.d/su

echo "Set Password Expiration Days"
sed -i'' -e 's/PASS_MAX_DAYS.*99999/PASS_MAX_DAYS 90/g' /etc/login.defs

echo "Set Password Change Minimum Number of Days"
sed -i'' -e 's/PASS_MIN_DAYS.*0/PASS_MIN_DAYS 7/g' /etc/login.defs

echo "Disable System Accounts"
for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd`; do
if [ $user != "root" ]
   then
      /usr/sbin/usermod -L $user
      if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]
      then
         /usr/sbin/usermod -s /sbin/nologin $user
      fi
fi done

echo "Set Default Group for root Account"
usermod -g 0 root

echo "Set Warning Banners"
touch /etc/motd
echo '               Unauthorised access prohibited' > /etc/motd
echo '                     All accesses are logged' >> /etc/motd
echo '*******************************************************************' >> /etc/motd
echo '*  WARNING:                                                       *' >> /etc/motd
echo '*      It is a criminal offence to:                               *' >> /etc/motd
echo '*      i.  Obtain access to data without authority                *' >> /etc/motd
echo '*          (Penalty 2 years imprisonment)                         *' >> /etc/motd
echo '*      ii. Damage, delete, alter or insert data without authority *' >> /etc/motd
echo '*          (Penalty 10 years imprisonment)                        *' >> /etc/motd
echo '*                                                                 *' >> /etc/motd
echo '*                                                                 *' >> /etc/motd
echo '*******************************************************************' >> /etc/motd
chown root:root /etc/motd
chmod 644 /etc/motd
echo "" > /etc/issue
chown root:root /etc/issue
chmod 644 /etc/issue
echo "" > /etc/issue.net
chown root:root /etc/issue.net
chmod 644 /etc/issue.net

echo "Verify Permissions on /etc/passwd"
/bin/chmod 644 /etc/passwd

echo "Verify Permissions on /etc/shadow"
/bin/chmod 000 /etc/shadow

echo "Verify Permissions on /etc/gshadow"
/bin/chmod 000 /etc/gshadow

echo "Verify Permissions on /etc/group"
/bin/chmod 644 /etc/group

echo "Verify User/Group Ownership on /etc/passwd"
/bin/chown root:root /etc/passwd

echo "Verify User/Group Ownership on /etc/shadow"
/bin/chown root:root /etc/shadow

echo "Verify User/Group Ownership on /etc/gshadow"
/bin/chown root:root /etc/gshadow

echo "Verify User/Group Ownership on /etc/group"
/bin/chown root:root /etc/group

echo "Software Support Requirements"
echo "Streams"
echo '* - nofile 100000' > /etc/security/limits.d/91-nofile.conf
