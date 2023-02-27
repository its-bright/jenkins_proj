#Create an elastic ip
resource "aws_eip" "jenkins_ip" {
  vpc = true
  
  tags = {
    Name = "eip-jenkins"
  }
}

#Associate the elastic ip to jenkins instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.jenkins_instance.id
  allocation_id = aws_eip.jenkins_ip.id
}
