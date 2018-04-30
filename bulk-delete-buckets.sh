#!/bin/sh

[ $# -ne 1 ] && {
  echo "$0 <bucket name regex>";
  exit 1;
}

regex=$1

for b in `aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | match("'${regex}'")) | .Name'`
do
  echo $b
  aws s3 rb --force s3://${b} 2>&1 >/dev/null
done;
