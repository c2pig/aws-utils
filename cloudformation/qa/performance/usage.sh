#!/bin/sh
stack_name=${1:-jmeter-distributed}
slave01_ip=`aws cloudformation describe-stacks --stack-name $stack_name| jq -r -c '.Stacks[].Outputs[] | select(.OutputKey == "Slave01") | .OutputValue'`
slave02_ip=`aws cloudformation describe-stacks --stack-name $stack_name| jq -r -c '.Stacks[].Outputs[] | select(.OutputKey == "Slave02") | .OutputValue'`
master_ip=`aws cloudformation describe-stacks --stack-name $stack_name| jq -r -c '.Stacks[].Outputs[] | select(.OutputKey == "Master") | .OutputValue'`
secret_key=`cat parameters.json | jq -r -c '.[]| select(.ParameterKey == "EC2Key")| .ParameterValue'`
#echo slave 1: $slave01_ip
#echo slave 2 : $slave02_ip
#echo master: $master_ip
#[ -e ${secret_key}.pem ] && {
#  echo "Error: need ${secret_key}.pem connect to ${master_ip}"
#  exit 1;
#}
section() {
  seq=$1
  desc=$2
  echo "#"
  echo "# $seq - $desc"
  echo "#"
}
[ ! -z $slave01_ip ] && [ ! -z $slave02_ip ] && [ ! -z $master_ip ] && {
  section 1 "Run following command to establish SSH tunnel(be sure ${secret_key}.pem is exists)"
  echo ssh -o StrictHostKeyChecking=no ubuntu@${master_ip} -i ${secret_key}.pem -L 24001:$slave01_ip:24001 -L 26001:$slave01_ip:26001 -L 24002:$slave02_ip:24002 -L 26002:$slave02_ip:26002 -R \*:25000:127.0.0.1:25000 -g
  section 2.1 "Run following command for GUI based JMeter"
  echo "./utils/jmeters.sh $master_ip -t <your test plan>"
  echo
  echo "# OR"
  echo
  section 2.2 "Run following command for non-GUI based JMeter"
  echo "./utils/jmeters-non-gui.sh $master_ip -t <your test plan>"
}
