#!bin/bash

yum install python3.12-pip.noarch -y | tee -a /opt/userdata.log
pip3.12 install botocore boto3 | tee -a /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/koteswaraRao559/expense-ansible expense.yml -e role_name = ${role_name} -e env= ${env} | tee -a /opt/userdata.log