variable "desired_capacity" {
  description = "Desired number of instances"
  type        = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = 1
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = 1
}

variable "health_check_type" {
  description = "Health check type (EC2, ELB)"
  type        = ELB
}

variable "health_check_grace_period" {
  description = "Time (in seconds) for health check grace period"
  type        = 30
}

variable "vpc_zone_identifier" {
  description = "List of VPC subnet IDs for ASG"
  type        = list(string)
}

variable "launch_template_id" {
  description = "The ID of the launch template"
  type        = string
}

variable "launch_template_version" {
  description = "Version of the launch template"
  type        = string
  default     = "$Latest"
}

variable "target_group_arns" {
  description = "List of Target Group ARNs"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the Auto Scaling Group"
  type        = list(object({
    key                 = string
    value               = string
    propagate_at_launch = bool
  }))
}

variable "termination_policies" {
  description = "Termination policies for the ASG"
  type        = list(string)
}
