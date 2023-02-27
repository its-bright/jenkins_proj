#! /bin/bash
#####################################################################################
## This script runs on the jenkins instance to 
## Install firewalld
## System enable firewalld
## restart firewalld
#####################################################################################

#install Firewalld
echo -e "****** [init_jenkins_instance.sh] Installing firewalld"
sudo yum install -y firewalld

#Enable Firewalld
echo -e "****** [init_jenkins_instance.sh] Enable firewalld"
sudo systemctl enable firewalld

echo -e "****** [init_jenkins_instance.sh] Restart firewalld"
sudo systemctl restart firewalld


