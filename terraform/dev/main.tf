terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  shared_credentials_file = "/Users/mac/.aws/credentials"
  profile  = "default"
  region = "af-south-1"
}


resource "aws_instance" "staging-server" {
  ami           = "ami-080bc3824e96f9b8d"
  instance_type = var.instance_type
 key_name = aws_key_pair.staging-key.id

 tags = {
    Name = var.ec2_tag
 }
 security_groups = ["launch-wizard-4"]

 ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "standard"
    volume_size = 100
  }
}

resource "aws_key_pair" "staging-key" {
  key_name   = "fmm-staging"
  public_key = var.public_key
}

resource "aws_security_group" "SecurityGroup" {
  name = "allow-postgresql-traffic"
  description = "A security group that allows inbound access to a PostgreSQL DB instance."
  vpc_id = ""

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [""]
    description = "Allow connections to a PostgreSQL DB instance"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}