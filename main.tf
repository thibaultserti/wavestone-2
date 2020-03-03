provider "aws" {
  region = "eu-west-3"
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



resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

resource "aws_elb" "elb1" {
  name               = "terraform-elb"
  availability_zones = data.aws_availability_zones.allzones.names

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  security_groups = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_outbound.id,
    aws_security_group.allow_http_traffic.id
  ]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

}

resource "aws_launch_configuration" "webserver" {
  name_prefix                = "terraform-lc-example-"
  image_id                   = data.aws_ami.ubuntu.id
  instance_type              = "t2.micro"
  key_name                   = aws_key_pair.terraform_key.key_name
  associate_public_ip_address = "false"

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    aws_security_group.allow_outbound.id,
    aws_security_group.allow_http_traffic_from_lb.id
  ]

}

resource "aws_autoscaling_group" "bar" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.webserver.name
  min_size             = 2
  max_size             = 2
  availability_zones   = data.aws_availability_zones.allzones.names
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.elb1.name]

  lifecycle {
    create_before_destroy = true
  }
}

output "elb-dns" {
  value = aws_elb.elb1.dns_name
}