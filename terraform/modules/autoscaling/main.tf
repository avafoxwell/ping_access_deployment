resource "aws_autoscaling_group" "example" {
  desired_capacity         = var.desired_capacity
  max_size                 = var.max_size
  min_size                 = var.min_size
  health_check_type        = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  vpc_zone_identifier      = var.vpc_zone_identifier

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  target_group_arns = var.target_group_arns

  termination_policies = var.termination_policies
}
