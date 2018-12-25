yum remove cloudera-*
umount cm_processes
rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera*
rm /tmp/.scm_prepare_node.lock
yum clean all
