#!/bin/sh
 
ansible-playbook --check --list-tasks -i $1
 
if [ $? -ne 0 ]
then
    exit 1
fi
