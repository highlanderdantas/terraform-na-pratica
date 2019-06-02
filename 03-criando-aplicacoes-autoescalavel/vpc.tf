resource "aws_vpc" "tst-vpc" {
  cidr_block = "${var.vpc_cdir}"

  tags = {
    Name        = "tst-vpc"
    Description = "VPC de teste"
  }
}

resource "aws_internet_gateway" "tst-gw" {
  vpc_id = "${aws_vpc.tst-vpc.id}"

  tags = {
    Name        = "tst-gw"
    Description = "GW de teste"
  }
}

resource "aws_subnet" "tst-subnet-public-a" {
  vpc_id            = "${aws_vpc.tst-vpc.id}"
  cidr_block        = "${var.public_a_cdir}"
  availability_zone = "${var.region}a"

  tags = {
    Name = "tst-subnet-public-a"
  }
}

resource "aws_subnet" "tst-subnet-public-b" {
  vpc_id            = "${aws_vpc.tst-vpc.id}"
  cidr_block        = "${var.public_b_cdir}"
  availability_zone = "${var.region}b"

  tags = {
    Name = "tst-subnet-public-b"
  }
}

resource "aws_subnet" "tst-subnet-private-a" {
  vpc_id            = "${aws_vpc.tst-vpc.id}"
  cidr_block        = "${var.private_a_cdir}"
  availability_zone = "${var.region}a"

  tags = {
    Name = "tst-subnet-private-a"
  }
}

resource "aws_subnet" "tst-subnet-private-b" {
  vpc_id            = "${aws_vpc.tst-vpc.id}"
  cidr_block        = "${var.private_b_cdir}"
  availability_zone = "${var.region}b"

  tags = {
    Name = "tst-subnet-private-b"
  }
}

resource "aws_route_table" "tst-route-table-public" {
  vpc_id = "${aws_vpc.tst-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tst-gw.id}"
  }

  tags = {
    Name = "tst-route-table-public"
  }
}

resource "aws_route_table" "tst-route-table-private" {
  vpc_id = "${aws_vpc.tst-vpc.id}"

  tags = {
    Name = "tst-route-table-private"
  }
}

resource "aws_route_table_association" "tst-route-table-association-public-a" {
  subnet_id      = "${aws_subnet.tst-subnet-public-a.id}"
  route_table_id = "${aws_route_table.tst-route-table-public.id}"
}

resource "aws_route_table_association" "tst-route-table-association-public-b" {
  subnet_id      = "${aws_subnet.tst-subnet-public-b.id}"
  route_table_id = "${aws_route_table.tst-route-table-public.id}"
}

resource "aws_route_table_association" "tst-route-table-association-private-a" {
  subnet_id      = "${aws_subnet.tst-subnet-private-a.id}"
  route_table_id = "${aws_route_table.tst-route-table-private.id}"
}

resource "aws_route_table_association" "tst-route-table-association-private-b" {
  subnet_id      = "${aws_subnet.tst-subnet-private-b.id}"
  route_table_id = "${aws_route_table.tst-route-table-private.id}"
}

resource "aws_security_group" "tst-webserver" {
  name        = "tst-webserver"
  description = "Allow public inbound traffic"
  vpc_id      = "${aws_vpc.tst-vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cdir}"]
    description = "ICMP"
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.private_a_cdir}"]
    description = "Database"
  }

  tags {
    Name = "Web server"
  }
}

resource "aws_security_group" "tst-database" {
  name        = "tst-database"
  description = "Allow incoming databse connections"
  vpc_id      = "${aws_vpc.tst-vpc.id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.tst-webserver.id}"]
    description     = "Database"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cdir}"]
    description = "SSH"
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cdir}"]
    description = "ICMP"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  tags {
    Name = "Database"
  }
}
