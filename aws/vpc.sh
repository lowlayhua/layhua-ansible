#!/bin/bash
# Create VPC for Optus Project
aws ec2 create-subnet --vpc vpc-eb7f978f --cidr 10.10.1.0/24 --a ap-southeast-2a
aws ec2 create-subnet --vpc vpc-eb7f978f --cidr 10.10.2.0/24 --a ap-southeast-2b
