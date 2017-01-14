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
