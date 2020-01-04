# Collect information
```
lsb_release -a
cat /etc/cloudera-scm-server/db.properties
Log in to the Cloudera Manager Admin console and find the following:
a. The version of Cloudera Manager used in your cluster. Go to Support
> About.
b. The version of the JDK deployed in the cluster. Go to Support > Abo
ut.
``` 
# Backup Cloudera Manager
```
0:web UI Cloudera mgr:Stop all service & management service
Stop Cloudera Manager Server & Cloudera Management Service
1. Stop the Cloudera Management Service.
a. Log in to the Cloudera Manager Admin Console.
b. Select Clusters > Cloudera Management Service.
c. Select Actions > Stop.
```
```
Run in xxx-mgmt-cm01
1a:ansible HDP -i hosts -a "service cloudera-manager-agent stop" -b
1b:ansible localhost -i hosts -a "service cloudera-manager-agent stop"
-b
2:Backup json
DD=`date +%Y%m%d`
curl -u admin:xxx -k https://xxx-mgmt-cm01.swg.tech.gov.sg:718
3/api/v12/cm/deployment > ${DD}.json
 ```
# 3:Backup mysql
```
DD=`date +%Y%m%d`
mysqldump -u root -p --all-databases --single-transaction --quick --lock-tables=false > $DD.sql
``` 
 
# 4:Backup metadata in xxx-hdp-01 & xxx-hdp-02:
```
/opt/admin/scripts/backup_NN_metadata.sh
```

# Upgrade Cloudera Manager

## 5: Run in xxx-mgmt-cm01
```
service stop cloudera-manager-agent
service stop cloudera-manager-server
dpkg -i cloudera-manager-daemons_6.2.0_968826.ubuntu1604_all.deb
dpkg -i  cloudera-manager-server_6.2.0~968826.ubuntu1604_all.deb
dpkg -i cloudera-manager-agent_6.2.0_968826.ubuntu1604_amd64.deb
``` 
## 6: Run in xxx-hdp-0[1-6]
```
dpkg-query -l 'cloudera-manager-*'
dpkg -i cloudera-manager-daemons_6.2.0_968826.ubuntu1604_all.deb
dpkg -i cloudera-manager-agent_6.2.0_968826.ubuntu1604_amd64.deb
pkg-query -l 'cloudera-manager-*'
```

## 7: Run in CM
```
ansible HDP -i hosts -a "service cloudera-manager-agent start" -b
service cloudera-manager-server start
``` 
## 8: Web UI: https://xxx-mgmt-cm01:7183/cmf/upgrade
 
