#VPC id
variable vpc_id {
    default = "<provide vpc id>"
}

#EC2 variables for control instance
variable control_instance_map {
    type = map
    default = {
        ami                 = "ami-0c9978668f8d55984"
        instance_type       = "t2.micro"
        key_name            = "<provide ec2 key name without .pem>"
        subnet_id           = "<provide subnet id>"
        userdata_script     = "init_control_instance.sh"
        inventory_group     = "jenkins_hosts"
        user_name           = "ec2-user"
        local_keyfile_path  = "<path for the keyfile location>"    
    }
}

#EC2 variables for jenkins instance
variable jenkins_instance_map {
    type = map
    default = {
        ami             = "ami-0c9978668f8d55984"
        instance_type   = "t2.micro"
        key_name        = "<provide ec2 key name without .pem>"
        subnet_id       = "<provide subnet id>"
        userdata_script = "init_jenkins_instance.sh"      
    }
}

#Control instance security group name
variable ans_sg_name {
    default = "sg_ansible"
}

#Jenkins instance security group name
variable jenkins_sg_name {
    default = "sg_jenkins"
}