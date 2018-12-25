ansible zookeepers -a "cat /data/zookeeper_data/myid" -b
ansible zookeepers -a "cat /opt/zookeeper/conf/zoo.cfg" -b
ansible zookeepers -a "/opt/zookeeper-3.4.9/bin/zkServer.sh status /opt/zookeeper-3.4.9/conf/zoo.cfg" -b
