provider "aws" {
  region = "ap-northeast-1"
}   

  variable "instance_count" {
    default = 1
    type = number
  }

  resource "aws_key_pair" "key_pair" {
    public_key = file("/home/vaibhav/.ssh/id_rsa.pub")
    key_name = "terraform-key"
  }

  resource "aws_security_group" "ec2_sg" {
    name = "allow_ssh"
    description = "allow ssh traffic"

    ingress {
      description = "inbound ssh"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
      description = "inbound ssh"
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      description = "outbound"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  resource "aws_instance" "takeda_ec2" {
    count = var.instance_count
    key_name = aws_key_pair.key_pair.key_name
    ami = "ami-0f65fc8c24ec8d2a1"
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    instance_type = "t3.medium"
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name 

/*
    user_data = <<-EOF
              #!/bin/bash
              set -e

              apt update -y
              apt upgrade -y

              # Install Java 17
              apt install -y fontconfig openjdk-17-jre

              # Add Jenkins repo & key
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
                | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                https://pkg.jenkins.io/debian-stable binary/ \
                | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

              apt update -y
              apt install -y jenkins

              systemctl start jenkins
              systemctl enable jenkins
              EOF
*/

    root_block_device {
      volume_size = 20
      volume_type = "gp3"
      delete_on_termination = true
    }
    tags = {
      Name = "XJPTYO52444D00${count.index + 1}"
    }

  }

  resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  }

  resource "aws_iam_role_policy_attachment" "role_attach" {
    role = aws_iam_role.ec2_ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  resource "aws_iam_instance_profile" "instance_profile" {
    name = "ec2-profile"
    role = aws_iam_role.ec2_ssm_role.name
  }




/*

  data "aws_instances" "all" {
    filter {
      name   = "tag-key"
      values = ["Name"]
    }
  }

  output "filter_id" {
    value = data.aws_instances.all.ids
  }

  data "aws_caller_identity" "current" {}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "aws_ec2_instance_state" "stop" {
  count = length(aws_instance.takeda_ec2)
  state = "stopped"
  instance_id = aws_instance.takeda_ec2[count.index].id
} */