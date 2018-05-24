#!/bin/sh
stack_name=${1:-jmeter-distributed}
aws cloudformation create-stack --stack-name $stack_name --template-body file://jmeter-distributed.yml --capabilities CAPABILITY_IAM --parameters file://parameters.json
aws cloudformation wait stack-create-complete --stack-name ${stack_name}
