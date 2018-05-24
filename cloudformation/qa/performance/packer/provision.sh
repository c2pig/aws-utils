#!/bin/bash -x

sudo apt-get update
sudo apt-get install -y software-properties-common debconf-utils
sudo apt-get install -y python-pip
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
cd /home/ubuntu/
wget http://www-us.apache.org/dist/jmeter/binaries/apache-jmeter-3.2.tgz
tar -zxvf apache-jmeter-3.2.tgz
echo "export PATH=/home/ubuntu/apache-jmeter-3.2/bin:$PATH" >> ~/.bashrc
sudo chmod a+wr /etc/ssh/sshd_config
sudo echo "GatewayPorts  yes" >> /etc/ssh/sshd_config
sudo chmod a-wr /etc/ssh/sshd_config
sudo pip install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
