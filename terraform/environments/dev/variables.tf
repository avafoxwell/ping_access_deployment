variable "image_id" {
  default = "ami-0acc77abdfc7ed5a6"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "desired_capacity" {
  default = 1
}

variable "max_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "health_check_type" {
  default = "EC2"
}

variable "health_check_grace_period" {
  default = 300
}

variable "vpc_zone_identifier" {
  default = ["subnet-092afd877e79fc3b0"]
}

variable "target_group_arns" {
  default = ["arn:aws:elasticloadbalancing:eu-west-2:387372672913:targetgroup/dev-shasrv-euw2-ping-tg/93b6ca2362c9713d"]
}

variable "tags" {
  default = [
    {
      key                 = "Name"
      value               = "awssspingt01"
      propagate_at_launch = true
    },
    {
      key                 = "Patch Group"
      value               = "az1_02-04"
      propagate_at_launch = true
    },
    // Add other tags as needed
  ]
}

variable "termination_policies" {
  default = ["Default"]
}
