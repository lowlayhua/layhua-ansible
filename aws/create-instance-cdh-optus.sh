#!/bin/bash
# Author: lowlayhua@gmail.com

# Optus 
# cloudera CDH
# Rhel 7 ami-3f03c55c
# AMI ami-1ddc0b7e
# Centos ami-106aa373
aws ec2 run-instances --image-id ami-3f03c55c --count 3 \
--instance-type m3.xlarge --key-name ds-optus-ssh \
--user-data file://add-hdd-cdh.sh \
--security-group-ids sg-52122c36 \
--subnet-id subnet-6a61850f --associate-public-ip-address \
--block-device-mappings file://mapping-hdd-cdh-optus.json
