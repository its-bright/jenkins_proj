#Create an ec2 instance to install jenkins
resource "aws_instance" "jenkins_instance" {
    ami = lookup(var.jenkins_instance_map, "ami")
    instance_type = lookup(var.jenkins_instance_map, "instance_type")
    key_name = lookup(var.jenkins_instance_map, "key_name")
    subnet_id = lookup(var.jenkins_instance_map, "subnet_id")
    
    user_data = file(lookup(var.jenkins_instance_map, "userdata_script"))

    vpc_security_group_ids = [
        aws_security_group.sg_jenkins.id
    ]

    tags = {"Name": "jenkins_ins"}
}


#Create a control instance to run ansible playbook and 
#install jennkins on jenkins instance
#Pass in userdata script to install prequisites as pip, ansible
#Provisioner to copy the jenkins role and playbook files onto the instance
resource "aws_instance" "control_ans_instance" {
    ami = lookup(var.control_instance_map, "ami")
    instance_type = lookup(var.control_instance_map, "instance_type")
    key_name = lookup(var.control_instance_map, "key_name")
    subnet_id = lookup(var.control_instance_map, "subnet_id")

    vpc_security_group_ids = [
        aws_security_group.sg_ans.id
    ]

    tags = {"Name": "control_ans_ins"}

    user_data = templatefile(lookup(var.control_instance_map, "userdata_script"),{ inventory_lines = ["[${lookup(var.control_instance_map, "inventory_group")}]","server1 ansible_host=${aws_instance.jenkins_instance.private_ip} ansible_user=${lookup(var.control_instance_map, "user_name")}"]})

    connection {
      type = "ssh"
      user = "ec2-user"
      #private_key = file("~/kys/myec2k.pem")
      private_key = file("${lookup(var.control_instance_map, "local_keyfile_path")}/${lookup(var.control_instance_map, "key_name")}.pem")
      host = self.public_ip
    }

    provisioner "remote-exec" {
      inline = [
        "mkdir /home/ec2-user/ansible_plays",
        "mkdir /home/ec2-user/ansible_plays/roles",
      ]
    }

    provisioner "file" {
      source = "../ansible_plays/jenkins-pbk.yml"
      destination = "/home/ec2-user/ansible_plays/jenkins-pbk.yml"
    }

    provisioner "file" {
      source = "../ansible_plays/roles/jenkins_role"
      destination = "/home/ec2-user/ansible_plays/roles"
    }

}