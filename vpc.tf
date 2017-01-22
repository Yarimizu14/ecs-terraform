resource "aws_vpc" "simple-cluster-vpc" {
  cidr_block = "200.0.0.0/16"
  tags {
    Name = "simple-cluster-vpc"
  }
}

resource "aws_internet_gateway" "simple-cluster-vpc-ig" {
  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"
  tags {
    Name = "simple-cluster-vpc-ig"
  }
}

resource "aws_subnet" "simple-cluster-vpc-subnet-0" {
  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"
  cidr_block = "200.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags {
    Name = "simple-cluster-vpc-subnet-0"
  }
}

resource "aws_route_table" "simple-cluster-vpc-subnet-0-rt" {
  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.simple-cluster-vpc-ig.id}"
  }
  tags {
    Name = "simple-cluster-vpc-subnet-0-rt"
  }
}

resource "aws_route_table_association" "simple-cluster-vpc-subnet-0-rt-assn" {
  subnet_id = "${aws_subnet.simple-cluster-vpc-subnet-0.id}"
  route_table_id = "${aws_route_table.simple-cluster-vpc-subnet-0-rt.id}"
}


resource "aws_subnet" "simple-cluster-vpc-subnet-1" {
  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"
  cidr_block = "200.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  tags {
    Name = "simple-cluster-vpc-subnet-1"
  }
}

resource "aws_route_table" "simple-cluster-vpc-subnet-1-rt" {
  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.simple-cluster-vpc-ig.id}"
  }
  tags {
    Name = "simple-cluster-vpc-subnet-1-rt"
  }
}

resource "aws_route_table_association" "simple-cluster-vpc-subnet-1-rt-assn" {
  subnet_id = "${aws_subnet.simple-cluster-vpc-subnet-1.id}"
  route_table_id = "${aws_route_table.simple-cluster-vpc-subnet-1-rt.id}"
}
