
resource "aws_vpc" "vpc_demo" {
  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink

  tags = {
      Name = var.tags
    }

}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc_demo.id}"

  tags = {
    Name = "internet-gateway-demo"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc_demo.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"
availability_zone="us-east-1a"

  tags = {
    Name = "public_1-demo"
  }
}
resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.vpc_demo.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.2.0/24"
availability_zone="us-east-1b"

  tags = {
    Name = "public_2-demo"
  }
}
resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.vpc_demo.id
  map_public_ip_on_launch = false
  cidr_block = "10.0.3.0/24"
  availability_zone="us-east-1a"

  tags = {
    Name = "private_1-demo"
  }
}
resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.vpc_demo.id
  map_public_ip_on_launch = false
  cidr_block = "10.0.4.0/24"
  availability_zone="us-east-1b"


  tags = {
    Name = "private_2-demo"
  }
}
resource "aws_route_table" "route-public" {
  vpc_id = "${aws_vpc.vpc_demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "public-route-table-demo"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.route-public.id}"
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = "${aws_subnet.public_2.id}"
  route_table_id = "${aws_route_table.route-public.id}"
}
resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_1.id}"
  depends_on    = [aws_internet_gateway.gw]
}

resource "aws_route_table" "route_private" {
  vpc_id = "${aws_vpc.vpc_demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }

  tags = {
    Name = "private-route-table-demo"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.route_private.id}"
}
resource "aws_route_table_association" "private_2" {
  subnet_id      = "${aws_subnet.private_2.id}"
  route_table_id = "${aws_route_table.route_private.id}"
}

resource "aws_db_subnet_group" "default" {
  subnet_ids = ["${aws_subnet.private_1.id}", "${aws_subnet.private_2.id}"]
  tags = {
    Name = "My DB subnet group"
  }

}

