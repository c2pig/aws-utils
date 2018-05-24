#!/bin/sh

aws cloudformation delete-stack --stack-name jmeter-distributed
aws cloudformation wait stack-delete-complete --stack-name jmeter-distributed
