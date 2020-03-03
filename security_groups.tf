resource "aws_security_group" "allow_outbound" {
  name        = "allow_outbound"
  description = "Allow outbound traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_http_traffic" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic from Rez IPs"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.rez_cidr]
  }
}

resource "aws_security_group" "allow_traffic_with_elb" {
  name        = "allow_traffic_elb"
  description = "Allow traffic with ELB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      aws_elb.elb1.source_security_group_id
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = [
      aws_elb.elb1.source_security_group_id
    ]
  }
}
