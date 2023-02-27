#! /bin/bash
#####################################################################################
## This script is a template file called as user_data to the ansible control instance 
## to do the prerequisite isntllations. It installs Python Pip
## Installs ansbile, Creates directories for jenkins role as needed
## Creates an inventory file and populates the inventory file 
## based on the input received as argument vars
#####################################################################################
#Set variables
SUDO_USER=ec2-user
ANSIBLE_PLAYS_DIR=/home/ec2-user/ansible_plays
ANSIBLE_ROLES_DIR=/home/ec2-user/ansible_plays/roles
INVENTORY_FILE=/home/ec2-user/ansible_plays/inventory.txt

#install Pip
echo -e "****** [init_control_instance.sh] Installing Pip"
sudo yum -y install python3-pip

#install ansible
echo -e "****** [init_control_instance.sh] Installing ansible"
sudo -u $SUDO_USER python3 -m pip install --user ansible

#Create ansible directory
echo -e "****** [init_control_instance.sh] Creating directories"
if [ -d "$ANSIBLE_PLAYS_DIR" ]; then
    echo "$ANSIBLE_PLAYS_DIR dir exists , so not creating"
else
    echo "****** [init_control_instance.sh] Creating $ANSIBLE_PLAYS_DIR dir"
    sudo -u $SUDO_USER mkdir $ANSIBLE_PLAYS_DIR
fi

if [ -d "$ANSIBLE_ROLES_DIR" ]; then
    echo "$ANSIBLE_ROLES_DIR dir exists , so not creating"
else
    echo "****** [init_control_instance.sh] Creating $ANSIBLE_ROLES_DIR dir"
    sudo -u $SUDO_USER mkdir $ANSIBLE_ROLES_DIR
fi

#Change dir
cd $ANSIBLE_PLAYS_DIR

#Create inventory file
echo -e "****** [init_control_instance.sh] Creating inventory file"
sudo -u $SUDO_USER touch $INVENTORY_FILE

#Populate the inventory file with the lines array received in the input
echo -e "****** [init_control_instance.sh] Populating inventory file"
%{ for line in inventory_lines }
    echo "${line}"
    echo "${line}" >> $INVENTORY_FILE
%{ endfor ~}


