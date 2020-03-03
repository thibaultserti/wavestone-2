provider "aws" {
  region = "eu-west-3"
}


resource "aws_elb" "elb1" {
  name = "terraform-elb"

  depends_on = [aws_internet_gateway.igw]

  subnets = [
    aws_subnet.main_a.id,
    aws_subnet.main_b.id,
    aws_subnet.main_c.id
  ]

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
