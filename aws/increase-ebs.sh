#!/bin/bash
#--------------------------------------------------------------
# Description: Increase 48 EC2 instances EBS Volume to 550G
# 1. Get EC2 instance Id
# 2. Get EBS Volume-id
# 3. Modify EBS size to 550
# 4. Use ansible to resize2fs
# 5. Use ansible to Verify /mnt2 disk size
#--------------------------------------------------------------

NAME="dataeng-memsql-leaf-prod"
SIZE=550

#--------------------------------------------------------------
ID="$(aws ec2 describe-instances \
  --filter 'Name=tag:Name,Values=dataeng-memsql-leaf-prod' 'Name=instance-state-name,Values=running' \
  --query '[Reservations[*].Instances[*].InstanceId]' --output text)"

for INSTANCE_ID in $ID;
do
  echo "# ${INSTANCE_ID}"
  VOL=`aws ec2 describe-volumes \
    --region us-east-1 \
    --filters Name=attachment.instance-id,Values=${INSTANCE_ID} Name=attachment.device,Values="/dev/xvdb" \
    --query "Volumes[*].{ID:VolumeId}" --output text`

  if [ -z ${VOL}  ]; then
  VOL=`aws ec2 describe-volumes \
    --region us-east-1 \
    --filters Name=attachment.instance-id,Values=${INSTANCE_ID} Name=attachment.device,Values="/dev/sdb" \
    --query "Volumes[*].{ID:VolumeId}" --output text`
  fi
  echo "# ${INSTANCE_ID} ${VOL}"
  echo "aws ec2 modify-volume  --size ${SIZE} --volume-id ${VOL}"
#  aws ec2 modify-volume  --size ${SIZE} --volume-id ${VOL}"
done
#ansible  -i ec2.py  tag_Name_dataeng_memsql_leaf_prod -m shell -a "resize2fs /dev/xvdb" -b
# Check

#ansible  -i ec2.py  tag_Name_dataeng_memsql_leaf_prod -m shell -a "df -h /mnt2"
#ansible  -i ec2.py  tag_Name_dataeng_memsql_leaf_prod -m shell -a "df -h /mnt2" | grep 542G |wc
