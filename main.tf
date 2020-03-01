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

resource "aws_instance" "webserver" {
  ami           = "ami-096b8af6e7e8fb927"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform_key.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_outbound.id,
    aws_security_group.allow_http_traffic.id
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.terraform_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y",
      "sudo apt install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }
}
