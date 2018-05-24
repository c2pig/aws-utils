#!/bin/bash
PS3="Please enter your choice: "
stream_opts=(
"CAIN"
"CPP"
"SALARY"
"EL"
"AI"
"EDU"
"SRP"
"VIDINT"
"HI"
)

region_opts=(
"US East (Ohio)"
"US East (N. Virginia)"
"US West (N. California"
"US West (Oregon)"
"Asia Pacific (Mumbai)"
"Asia Pacific (Seoul)"
"Asia Pacific (Singapore)"
"Asia Pacific (Sydney)"
"Asia Pacific (Tokyo)"
"Canada (Central)"
"EU (Frankfurt)"
"EU (Ireland)"
"EU (London)"
"South America (São Paulo)"
)

env_opts=(
"Production"
"Development"
)

select opt in "${stream_opts[@]}"
do
  case $opt in
    "CAIN")
        stream=cain;
        break;
        ;;
    "CPP")
        stream=cpp;
        break;
        ;;
    "SALARY")
        stream=salary;
        break;
        ;;
    "EL")
        stream=el;
        break;
        ;;
    "AI")
        stream=ai;
        break;
        ;;
    "EDU")
        stream=edu;
        break;
        ;;
    "SRP")
        stream=srp;
        break;
        ;;
    "VIDINT")
        stream=vidint;
        break;
        ;;
    "HI")
        stream=hi;
        break;
        ;;
    *) echo invalid option; exit 1;;
esac

select opt in "${region_opts[@]}"
do
  case $opt in
    "US East (Ohio)")
      region=us-east-2
      break;
      ;;
    "US East (N. Virginia)")
      region=us-east-1
      break;
      ;;
    "US West (N. California)")
      region=us-west-1
      break;
      ;;
    "US West (Oregon)")
      region=us-west-2
      break;
      ;;
    "Asia Pacific (Mumbai)")
      region=ap-south-1
      break;
      ;;
    "Asia Pacific (Seoul)")
      region=ap-northeast-2
      break;
      ;;
    "Asia Pacific (Singapore)")
      region=ap-southeast-1
      break;
      ;;
    "Asia Pacific (Sydney)")
      region=ap-southeast-2
      break;
      ;;
    "Asia Pacific (Tokyo)")
      region=ap-northeast-1
      break;
      ;;
    "Canada (Central)")
      region=ca-centra-1
      break;
      ;;
    "EU (Frankfurt)")
      region=eu-central-1
      break;
      ;;
    "EU (Ireland)")
      region=eu-west-1
      break;
      ;;
    "EU (London)")
      region=eu-west-2
      break;
      ;;
    "South America (São Paulo)")
      region=sa-east-1
      break;
      ;;
    *) echo invalid option; exit 1 ;;
 esac 
done
done
###
select opt in "${region_opts[@]}"
do
  case $opt in
    "US East (Ohio)")
      region=us-east-2;
      break;
      ;;
    "US East (N. Virginia)")
      region=us-east-1;
      break;
      ;;
    "US West (N. California)")
      region=us-west-1;
      break;
      ;;
    "US West (Oregon)")
      region=us-west-2;
      break;
      ;;
    "Asia Pacific (Mumbai)")
      region=ap-south-1;
      break;
      ;;
    "Asia Pacific (Seoul)")
      region=ap-northeast-2;
      break;
      ;;
    "Asia Pacific (Singapore)")
      region=ap-southeast-1;
      break;
      ;;
    "Asia Pacific (Sydney)")
      region=ap-southeast-2;
      break;
      ;;
    "Asia Pacific (Tokyo)")
      region=ap-northeast-1;
      break;
      ;;
    "Canada (Central)")
      region=ca-centra-1;
      break;
      ;;
    "EU (Frankfurt)")
      region=eu-central-1;
      break;
      ;;
    "EU (Ireland)")
      region=eu-west-1;
      break;
      ;;
    "EU (London)")
      region=eu-west-2;
      break;
      ;;
    "South America (São Paulo)")
      region=sa-east-1
      break;
      ;;
    *) echo invalid option; exit 1 ;;
  esac
done
####
select opt in "${env_opts[@]}"
do
  case $opt in
    "Production")
      env=prod;
      break;
      ;;
    "Development")
      env=dev;
      break;
      ;;
  esac
done

vpc_cidr=`cat ips-range.json | jq  -r ''".vpc_cidr.${env}.${stream}[\"${region}\"]"''`
[ "$vpc_cidr" == "null" ] && {
  echo "[Error]: VPC CIDR mapping for $stream in ${region}/$env is not found"
  exit 1;
}
prefix=25
public_subnet_prefix=128/$prefix
private_subnet_prefix=0/$prefix
public_subnet_a=`echo $vpc_cidr | awk -F '.' '{print $1"."$2"."$3".'$public_subnet_prefix'"}'`
public_subnet_b=`echo $vpc_cidr | awk -F '.' '{print $1"."$2"."$3+1".'$public_subnet_prefix'"}'`
public_subnet_c=`echo $vpc_cidr | awk -F '.' '{print $1"."$2"."$3+2".'$public_subnet_prefix'"}'`
private_subnet_a=`echo $vpc_cidr | awk -F '.' '{print $1"."$2"."$3".'$private_subnet_prefix'"}'`
private_subnet_b=`echo $vpc_cidr | awk -F '.' '{print $1"."$2"."$3+1".'$private_subnet_prefix'"}'`
private_subnet_c=`echo $vpc_cidr | awk -F '.' '{print $1"."$2"."$3+2".'$private_subnet_prefix'"}'`

creator=`aws iam get-user | jq -r .User.UserName`
azs=`aws ec2 describe-availability-zones --region $region| jq -r '.AvailabilityZones | length'`

 aws cloudformation create-stack --stack-name vpc-$stream-$env --region $region --template-body file://vpc.yml \
  --parameters  ParameterKey=Environment,ParameterValue=$env \
    ParameterKey=Creator,ParameterValue=$creator \
    ParameterKey=Owner,ParameterValue=$creator \
    ParameterKey=ProjectTeam,ParameterValue=$stream \
    ParameterKey=Stream,ParameterValue=$stream \
    ParameterKey=VPCName,ParameterValue=vpc-$stream-$env \
    ParameterKey=VPCCIDRBlock,ParameterValue=$vpc_cidr \
    ParameterKey=SubnetACIDRBlock,ParameterValue=$private_subnet_a \
    ParameterKey=SubnetBCIDRBlock,ParameterValue=$private_subnet_b \
    ParameterKey=SubnetCCIDRBlock,ParameterValue=$private_subnet_c \
    ParameterKey=SubnetWebACIDRBlock,ParameterValue=$public_subnet_a \
    ParameterKey=SubnetWebBCIDRBlock,ParameterValue=$public_subnet_b \
    ParameterKey=SubnetWebCCIDRBlock,ParameterValue=$public_subnet_c \
    ParameterKey=NumOfAZ,ParameterValue=$azs

