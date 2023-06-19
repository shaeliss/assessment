provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins"
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "Jenkins-Master-TF" {
  ami           = "ami-022e1a32d3f742bd8"  # Replace with your desired AMI ID
  instance_type = "t2.small"                # Replace with your desired instance type
  key_name = "assessment-keypair" 
  tags = {
    Name = "Jenkins-Master-TF"               # Replace with your desired instance name
  }
vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y java-1.8.0-openjdk-devel
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum install -y jenkins
    sudo systemctl start jenkins
  EOF
}
resource "aws_instance" "Jenkins-Worker-TF" {
  ami           = "ami-022e1a32d3f742bd8"  # Replace with your desired AMI ID
  instance_type = "t2.small"                # Replace with your desired instance type
  key_name = "assessment-keypair"
  tags = {
    Name = "Jenkins-Worker-TF"               # Replace with your desired instance name
  }
vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
}
