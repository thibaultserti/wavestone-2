provider "aws" {
  region = "eu-west-3"
}

resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["webserver-ubuntu-apache-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}



data "aws_availability_zones" "allzones" {
  state = "available"
}

resource "aws_launch_configuration" "webserver" {
  name_prefix   = "terraform-lc-example-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform_key.key_name

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_outbound.id,
    aws_security_group.allow_http_traffic.id
  ]
}

resource "aws_autoscaling_group" "bar" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.webserver.name
  min_size             = 2
  max_size             = 2
  availability_zones   = data.aws_availability_zones.allzones.names
  health_check_type    = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}