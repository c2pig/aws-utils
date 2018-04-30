#!/bin/sh

[ $# -ne 1 ] && {
  echo "$0 <stack name regex>";
  exit 1;
}

regex=$1

# for b in `aws cloudformation list-stacks | jq -r '.Buckets[] | select(.Name | match("'${regex}'")) | .Name'`
for name in `aws cloudformation list-stacks | \
   jq -r '.StackSummaries[]  \
     | select (.StackStatus | contains("DELETE_COMPLETE") | not) \
     | select(.StackName | match("'${regex}'")) | .StackName'`
do
  echo Will delete $name
  aws cloudformation delete-stack --stack-name $name
done;
