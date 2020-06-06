#!/bin/bash
# 1. EC2 instance Id

ID="$(aws ec2 describe-instances \
  --filter 'Name=tag:Name,Values=dataeng-memsql-leaf-prod' 'Name=instance-state-name,Values=running' \
  --query '[Reservations[*].Instances[*].InstanceId]' --output text)"

for i in $ID;
do
  echo "# instance: "$i"";
# 2. Get EBS Volume-id
  instance_id=${i}
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
#aws ec2 modify-volume  --size 550 --volume-id ${VOL}
  fi

done
