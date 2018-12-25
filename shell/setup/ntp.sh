#!/bin/bash
# Written by Lay Hua

cp /etc/ntp.conf /etc/ntp.conf.orig
perl -pi -e 's/server 0.rhel.pool.ntp.org/#server 0.rhel.pool.ntp.org/' /etc/ntp.conf
perl -pi -e 's/server 1.rhel.pool.ntp.org/#server 1.rhel.pool.ntp.org/' /etc/ntp.conf
perl -pi -e 's/server 2.rhel.pool.ntp.org/#server 2.rhel.pool.ntp.org/' /etc/ntp.conf
perl -pi -e 's/server 3.rhel.pool.ntp.org/#server 3.rhel.pool.ntp.org/' /etc/ntp.conf
echo "server ntp2.singnet.com.sg" >> /etc/ntp.conf
echo "server ntp3.singnet.com.sg" >> /etc/ntp.conf
service ntpd restart
chkconfig ntpd on
ntpq -np
