provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_ecs_cluster" "simple-cluster" {
  name = "simple-cluster"
}

resource "aws_ecs_task_definition" "simple-task" {
  family = "simple-task"
  container_definitions = "${file("task-definitions/simple-app-container.json")}"
}

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

resource "aws_ecs_service" "simple-service" {
  name = "simple-service"
  cluster = "${aws_ecs_cluster.simple-cluster.id}"
  task_definition = "${aws_ecs_task_definition.simple-task.arn}"
  # iam_role = "ecsServiceRole"
  desired_count = 1

/*
  load_balancer {
    elb_name = "simple-cluster-service-elb"
    container_name = "simple-app"
    container_port = 5123
  }
*/
}

resource "aws_instance" "simple-cluster-instance" {
  count = 1
  instance_type = "${var.instance_type}"
  ami = "${lookup(var.aws_amis, var.region)}"
  # subnet_id = "subnet-26fb9450"
  subnet_id = "${aws_subnet.simple-cluster-vpc-subnet-0.id}"
  associate_public_ip_address = true
  # vpc_security_group_ids = ["sg-e657c081"] # ここ変えたら登録されなくなる
  iam_instance_profile = "ecsInstanceRole"
  key_name = "${var.ssh_key_name}"
  tags = {
    Name = "${lookup(var.tag_names, count.index)}"
  }
  user_data = "${file("user_data/userdata.sh")}"
}
