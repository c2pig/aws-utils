#!/bin/sh
zip slack.zip slack.js
aws s3api create-bucket --bucket gdp-engineering --region us-east-1
aws s3 sync . s3://gdp-engineering/cf/operation/
aws cloudformation create-stack --stack-name healthcheck-reboot  --template-body file://healthcheck.yml --region us-east-1 --capabilities CAPABILITY_IAM


