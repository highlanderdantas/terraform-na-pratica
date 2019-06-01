provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "tst-vpc" {
  cidr_block = "${var.cdir_block}"

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
  cidr_block        = "192.168.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "tst-subnet-public-a"
  }
}

resource "aws_subnet" "tst-subnet-public-b" {
  vpc_id            = "${aws_vpc.tst-vpc.id}"
  cidr_block        = "192.168.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "tst-subnet-public-b"
  }
}

resource "aws_subnet" "tst-subnet-private-a" {
  vpc_id            = "${aws_vpc.tst-vpc.id}"
  cidr_block        = "192.168.3.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "tst-subnet-private-a"
  }
}

resource "aws_subnet" "tst-subnet-private-b" {
  vpc_id            = "${aws_vpc.tst-vpc.id}"
  cidr_block        = "192.168.4.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "tst-subnet-private-b"
  }
}
