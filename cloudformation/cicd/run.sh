#!/bin/bash
aws cloudformation create-stack --stack-name aws-velocity-pipeline --template-body file://codepipeline.yml --capabilities CAPABILITY_IAM --parameters file://codepipeline.json
