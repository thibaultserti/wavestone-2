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

resource "aws_launch_configuration" "webserver" {
  name_prefix                 = "terraform-lc-example-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    aws_security_group.allow_outbound.id,
    aws_security_group.allow_traffic_with_elb.id
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
