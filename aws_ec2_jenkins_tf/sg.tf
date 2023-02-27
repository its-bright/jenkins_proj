locals {

    #SG rules for control instance
    ans_sg_ingress_rules = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["<your ip>"]
        }
    ]

   #SG rules for jenkins instance
   jenkins_sg_ingress_rules = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["<your ip>"]
        },
        {
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

    ]
}

#Create a security group for ansible control instance
resource "aws_security_group" "sg_ans" {
    name = var.ans_sg_name
    description = "Security Group for Ansible SG"
    vpc_id = var.vpc_id

    dynamic ingress {
        for_each = local.ans_sg_ingress_rules

        content {
          from_port = ingress.value.from_port
          to_port = ingress.value.to_port
          protocol = ingress.value.protocol
          cidr_blocks = ingress.value.cidr_blocks
          self = false
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

#Create a security group for jenkins instance
resource "aws_security_group" "sg_jenkins" {
    name = var.jenkins_sg_name
    description = "Security Group for Jenkins"
    vpc_id = var.vpc_id

    dynamic ingress {
        for_each = local.jenkins_sg_ingress_rules

        content {
          from_port = ingress.value.from_port
          to_port = ingress.value.to_port
          protocol = ingress.value.protocol
          cidr_blocks = ingress.value.cidr_blocks
          self = false
        }
    }

    ingress {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          self = false
          security_groups = [aws_security_group.sg_ans.id]
    }

    ingress {
          from_port = 8080
          to_port = 8080
          protocol = "tcp"
          self = false
          security_groups = [aws_security_group.sg_ans.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}