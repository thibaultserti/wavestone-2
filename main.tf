provider "aws" {
  region = "eu-west-3"
}

data "aws_availability_zones" "allzones" {
  state = "available"
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
