#!/bin/bash
aws cloudformation create-stack --stack-name qa-robot-pipeline --template-body file://pipeline.yml --capabilities CAPABILITY_IAM
