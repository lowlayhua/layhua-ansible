# Task: Increase the size of EC2 instance EBS volume to 550G with Name dataeng-memsql-leaf-prod
## 1. EC2 instance using tag:Name
```
ID="$(aws ec2 describe-instances \
  --filter 'Name=tag:Name,Values=dataeng-memsql-leaf-prod' 'Name=instance-state-name,Values=running' \
  --query '[Reservations[*].Instances[*].InstanceId]' --output text)"
```

## Get EBS Volume-id based ID
```
for instance_id in $ID;
do
  VOL=`aws ec2 describe-volumes \
    --region us-east-1 \
    --filters Name=attachment.instance-id,Values=${instance_id} Name=attachment.device,Values="/dev/xvdb" \
    --query "Volumes[*].{ID:VolumeId}" --output text`
if [ -z ${VOL}  ]; then
  VOL=`aws ec2 describe-volumes \
    --region us-east-1 \
    --filters Name=attachment.instance-id,Values=${instance_id} Name=attachment.device,Values="/dev/sdb" \
    --query "Volumes[*].{ID:VolumeId}" --output text`
  echo "aws ec2 modify-volume  --size 550 --volume-id ${VOL}" >> cmd-modify-vol-sdb.txt
  else
# Found /dev/xvdb and Increase 550G
  echo "aws ec2 modify-volume  --size 550 --volume-id ${VOL}" >> cmd-modify-vol-xvdb.txt
  fi
done
```

ansible  -i ec2.py  tag_Name_dataeng_memsql_leaf_prod -m shell -a "df /mnt2"
```
