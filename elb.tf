resource "aws_security_group" "simple-service-elb-sg" {
  name = "simple-service-elb-sg"

  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"

  ingress {
      from_port = 0
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "simple-service-elb-sg"
  }
}

resource "aws_elb" "simple-cluster-service-elb" {
  name = "simple-cluster-service-elb"
  # availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  subnets = ["${aws_subnet.simple-cluster-vpc-subnet-0.id}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  # connection_draining = true
  # connection_draining_timeout = 400

  tags {
    Name = "simple-cluster-service-elb"
  }
}
