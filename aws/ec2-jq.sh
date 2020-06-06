aws ec2 describe-instances \
  --filter 'Name=tag:Name,Values=dataeng-memsql-leaf-prod' 'Name=instance-state-name,Values=running' | \
  jq -r '.Reservations[].Instances[] | [.InstanceId, .PrivateIpAddress] | @csv'
