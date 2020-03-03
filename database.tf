resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "my_username"
  password             = random_password.password.result
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.default.name
}

resource "aws_db_subnet_group" "default" {
  name = "main"
  subnet_ids = [
    aws_subnet.main_a.id,
    aws_subnet.main_b.id,
    aws_subnet.main_c.id
  ]
}
