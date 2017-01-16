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

resource "aws_ecs_service" "simple-service" {
  name = "simple-service"
  cluster = "${aws_ecs_cluster.simple-cluster.id}"
  task_definition = "${aws_ecs_task_definition.simple-task.arn}"
  iam_role = "ecsServiceRole"
  desired_count = 1

  load_balancer {
    elb_name = "${aws_elb.simple-cluster-service-elb.name}"
    container_name = "simple-app"
    container_port = 5123
  }
}

resource "aws_security_group" "simple-service-app-sg" {
  name = "simple-service-app-sg"

  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "simple-service-app-sg"
  }
}

resource "aws_instance" "simple-cluster-instance" {
  count = 1
  instance_type = "${var.instance_type}"
  ami = "${lookup(var.aws_amis, var.region)}"
  subnet_id = "${aws_subnet.simple-cluster-vpc-subnet-0.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_vpc.simple-cluster-vpc.default_security_group_id}", "${aws_security_group.simple-service-app-sg.id}"]
  iam_instance_profile = "ecsInstanceRole"
  key_name = "${var.ssh_key_name}"
  tags = {
    Name = "${lookup(var.tag_names, count.index)}"
  }
  user_data = "${file("user_data/userdata.sh")}"
}
