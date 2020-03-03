data "aws_availability_zones" "allzones" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "main_a" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = "10.0.1.0/24"
  availability_zone_id = data.aws_availability_zones.allzones.zone_ids[0]
}

resource "aws_subnet" "main_b" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = "10.0.2.0/24"
  availability_zone_id = data.aws_availability_zones.allzones.zone_ids[1]
}

resource "aws_subnet" "main_c" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = "10.0.3.0/24"
  availability_zone_id = data.aws_availability_zones.allzones.zone_ids[2]
}

resource "aws_route_table_association" "rta_subnet_main_a_public" {
  subnet_id      = aws_subnet.main_a.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "rta_subnet_main_b_public" {
  subnet_id      = aws_subnet.main_b.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "rta_subnet_main_c_public" {
  subnet_id      = aws_subnet.main_c.id
  route_table_id = aws_route_table.rtb_public.id
}
