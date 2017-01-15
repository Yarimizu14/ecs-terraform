variable "access_key" {
  description = "AWS access key"
  default     = "ACCESSKEY"
}

variable "secret_key" {
  description = "AWS secret access key"
  default     = "SECRETKEY"
}

variable "region" {
  description = "AWS region to host your network"
  default     = "ap-northeast-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_amis" {
  default = {
      "ap-northeast-1" = "ami-30bdce57"
  }
}

variable "tag_names" {
  default = {
    "0" = "ecs-container-instance01",
    "1" = "ecs-container-instance02",
    "2" = "ecs-container-instance03"
  }
}

variable "ssh_key_name" {}
