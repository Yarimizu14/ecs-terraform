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
    # elb_name = "${aws_elb.simple-cluster-service-elb.name}"
    target_group_arn = "${aws_alb_target_group.simple-app-target-group.arn}"
    container_name = "simple-app"
    container_port = 5123
  }
}
