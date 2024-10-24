#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

# Variables
BUCKET_NAME="dev-shasrv-euw2-sharedresources-s3"
OPENJDK_FILE="Linux/PingIdentity/PingAccess-8.1.1/OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz"
PINGACCESS_FILE="Linux/PingIdentity/PingAccess-8.1.1/pingaccess-8.1.1.tar.gz"
RUN_PROPERTIES_FILE="Linux/PingIdentity/run.properties"

# Define installation paths
INSTALL_DIR="/opt/pingaccess"
JDK_DIR="/usr/java/jdk-17"

# Install necessary tools
yum update -y
yum install -y wget unzip aws-cli iptables-services

# Install OpenJDK
mkdir -p $JDK_DIR
aws s3 cp s3://$BUCKET_NAME/$OPENJDK_FILE /tmp/
tar -xvzf /tmp/OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz -C $JDK_DIR --strip-components=1

# Set JAVA_HOME and PATH environment variables
echo "export JAVA_HOME=$JDK_DIR" >> /etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile

# Verify Java installation
java -version

# Install PingAccess
mkdir -p $INSTALL_DIR
aws s3 cp s3://$BUCKET_NAME/$PINGACCESS_FILE /tmp/
tar -xvzf /tmp/pingaccess-8.1.1.tar.gz -C $INSTALL_DIR --strip-components=1

# Copy run.properties
aws s3 cp s3://$BUCKET_NAME/$RUN_PROPERTIES_FILE $INSTALL_DIR/conf/run.properties

# Configure PingAccess based on IP Address
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
IP_ADDRESS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

if [ "$IP_ADDRESS" == "10.52.49.29" ]; then
    aws s3 cp https://dev-shasrv-euw2-ping-linux-test.s3.eu-west-2.amazonaws.com/PingIdentity/Linux/pingaccess-7.3.6/awssspingt01.broadcast.bskyb.com_data/conf/bootstrap.properties $INSTALL_DIR/conf/
    aws s3 cp https://dev-shasrv-euw2-ping-linux-test.s3.eu-west-2.amazonaws.com/PingIdentity/Linux/pingaccess-7.3.6/awssspingt01.broadcast.bskyb.com_data/conf/pa.jwk $INSTALL_DIR/conf/
    aws s3 cp https://dev-shasrv-euw2-ping-linux-test.s3.eu-west-2.amazonaws.com/PingIdentity/Linux/pingaccess-7.3.6/awssspingt01.broadcast.bskyb.com_data/conf/pa.jwk.properties $INSTALL_DIR/conf/
elif [ "$IP_ADDRESS" == "10.52.49.69" ]; then
    aws s3 cp https://dev-shasrv-euw2-ping-linux-test.s3.eu-west-2.amazonaws.com/PingIdentity/Linux/pingaccess-7.3.6/awssspingt01b.broadcast.bskyb.com_data/conf/bootstrap.properties $INSTALL_DIR/conf/
    aws s3 cp https://dev-shasrv-euw2-ping-linux-test.s3.eu-west-2.amazonaws.com/PingIdentity/Linux/pingaccess-7.3.6/awssspingt01b.broadcast.bskyb.com_data/conf/pa.jwk $INSTALL_DIR/conf/
    aws s3 cp https://dev-shasrv-euw2-ping-linux-test.s3.eu-west-2.amazonaws.com/PingIdentity/Linux/pingaccess-7.3.6/awssspingt01b.broadcast.bskyb.com_data/conf/pa.jwk.properties $INSTALL_DIR/conf/
fi


# Start PingAccess service (assuming it has a service script or bin command)
cd $INSTALL_DIR/bin
./pingaccess start

# Set up iptables rules for PingAccess
iptables -A INPUT -p tcp -m multiport --dports 7610,7710 -s 10.52.49.0/25,10.20.38.69 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 3000 -s 10.52.49.192/26,10.253.28.0/23 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -s 10.52.49.192/26 -j ACCEPT

# Save iptables rules
service iptables save
systemctl enable iptables

# Sync time with NTP server
yum install -y ntp
ntpdate 192.168.41.1

# Log files setup and upload to S3
PA_LOG="/var/log/pingaccess-setup.log"
echo "PingAccess setup logs for instance $INSTANCE_ID" > $PA_LOG
aws s3 cp $PA_LOG s3://dev-shasrv-euw2-auditlogs-s3/ec2build_exportlogs/${INSTANCE_ID}_$(date +'%d-%m-%Y-%H-%M').log

# Reboot to apply changes
reboot
