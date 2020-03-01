provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "webserver" {
  ami           = "ami-096b8af6e7e8fb927"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_outbound.id
  ]
}