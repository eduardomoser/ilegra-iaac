terraform {
  required_version = ">= 1.2.1"
  required_providers {
    aws = ">= 4"
  }
  backend "s3" {
    bucket = "ilg-eduardo-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  profile                 = "default"
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = var.instance_type
  ebs_optimized = var.ebs_optimized

  tags = {
    Name = "HelloWorld3"
  }
}