resource "aws_security_group" "simple-service-elb-sg" {
  name = "simple-service-elb-sg"

  vpc_id = "${aws_vpc.simple-cluster-vpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "simple-service-elb-sg"
  }
}

# resource "aws_elb" "simple-cluster-service-elb" {
#   name = "simple-cluster-service-elb"
#
#   listener {
#     instance_port = 80
#     instance_protocol = "http"
#     lb_port = 80
#     lb_protocol = "http"
#   }
#
#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     target = "HTTP:80/"
#     interval = 30
#   }
#
#   subnets = ["${aws_subnet.simple-cluster-vpc-subnet-0.id}"]
#   security_groups = ["${aws_vpc.simple-cluster-vpc.default_security_group_id}", "${aws_security_group.simple-service-elb-sg.id}"]
#
#   cross_zone_load_balancing = true
#   idle_timeout = 400
#   connection_draining = true
#   connection_draining_timeout = 400
#
#   tags {
#     Name = "simple-cluster-service-elb"
#   }
# }

resource "aws_alb_target_group" "simple-app-target-group" {
  name     = "simple-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.simple-cluster-vpc.id}"
}

resource "aws_alb_target_group_attachment" "instance-01-target_group_attachment" {
  target_group_arn = "${aws_alb_target_group.simple-app-target-group.arn}"
  target_id = "${aws_instance.simple-cluster-instance.id}"
  port = 80
}

resource "aws_alb_listener" "simple-app-alb-listener" {
   load_balancer_arn = "${aws_alb.simple-cluster-service-elb.arn}"
   port = "80"
   protocol = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.simple-app-target-group.arn}"
     type = "forward"
   }
}

resource "aws_alb" "simple-cluster-service-elb" {
  name            = "simple-cluster-service-elb"
  internal        = false
  security_groups = ["${aws_vpc.simple-cluster-vpc.default_security_group_id}", "${aws_security_group.simple-service-elb-sg.id}"]
  subnets = ["${aws_subnet.simple-cluster-vpc-subnet-0.id}", "${aws_subnet.simple-cluster-vpc-subnet-1.id}"]

  enable_deletion_protection = false

  tags {
    Name = "simple-cluster-service-elb"
  }
}
