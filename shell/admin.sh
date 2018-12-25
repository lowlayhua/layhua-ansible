# install scripts for sysadm in /admin
cd /
wget http://gl-rhelsat.app.vic/admin.tgz
tar xvf /admin.tgz 

# crontab
echo "5 7-18 * * * /admin/diskspace.sh > /dev/null 2>&1" >> /var/spool/cron/root
chkconfig crond on
rm /admin.tgz

# cron.allow
cat << 'EOF' > /etc/cron.allow
root
oracle
EOF
