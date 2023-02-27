# jenkins_proj
This project aims at automating the jenkins installation using Terraform and Ansible onto AWS RHEL instances

It implements the below to achieve it:
## ansible_plays:
    This creates an ansible role to support
        - install jenkins
        - upgrade jenkins when upgrade available
        - patch jenkins
        - backup jenkins repo and files before upgrade/patch
    It also provides a playbook to call the role to install jenkins on a separate instance

## aws_ec2_jenkins_tf:
    This creates and launches: 
        - ansible control instance 
        - jenkins instance which will have host the jenkins server
    This also includes the automation to perform the prequisites on the control instance to:
        - install pip, ansible
        - create required directories
        - copy the ansible playbook and roles onto the instance
        - Build the inventory file with jenkins instance group
    It also creates the required security groups and EIPs
        
Further details can be found in readme files of each section.

