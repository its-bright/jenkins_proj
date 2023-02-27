# jenkins_proj/aws_ec2_jenkins_tf
This repo provides the terraform insfrastructure to create Ansible Control and Jenkins instances so as to be able to invoke ansible playbook from control instance to install jenkins onto jenkins instances

It assumes to use an existing VPC and subnets.

It implements the below as part of the infrastucure to add:
## Security Group: 
    - Two security groups are created one for control instance and one for Jenkins instance with the respective access rules

## Ansible Control instance:
    - This instance acts as jump server to run ansible playbook to install jenkins on Jenkins instance
    - As part of the launch of the instance, it accepts user data script to install pip and ansible
    - It builds the inventory file with the ipaddress of the Jenkins instance
    - It runs a provisioner to copy the jenkins role files and playbook files

## Jenkins server instance:
    - This instance is used by ansible from control instance to install jenkins on it
    - This instance has a public elastic ip so the ip for jenkins server doesnt change with relaunchs

## Elastic IP:
    - This is associated with the Jenkins instance
    - This is needed so as for the Jenkins instance Ip can remain constant

It supports storing the terraform state file in an S3 bucket.

## Variables
Ansible instance requires below map defined for variables:

```
#EC2 variables for control instance
variable control_instance_map {
    type = map
    default = {
        ami                 = "ami-0c9978668f8d55984"       # Corresponding AMI id
        instance_type       = "t2.micro"                    # instance type
        key_name            = "<your key name>"             # Your ssh key name
        subnet_id           = "<your subnet id>"            # Your subnet id
        userdata_script     = "init_ansible.sh"             # user data script for initializing
        inventory_group     = "jenkins_hosts"               # Jenkins hosts group name in inventory file. The same is to be used in the jenkins-pbk.yml playbook file
        user_name           = "ec2-user"                    # User name corresponding to your ami. Same is to be used in the jenkins-pbk.yml,init_ansible.sh
        local_keyfile_path  = "<your ec2 ssh key path>"     # Full path for your ec2 ssh key. ONly the path. Key anme will be taken from key_name attribute. This is used by the provisioner
    }
}
