module "launch_template" {
  source       = "../../modules/launch_template"
  template_name = "dev-shasrv-euw2-pingaz1-tmp"
  image_id      = var.image_id
  instance_type = var.instance_type
  tags          = var.tags
}

module "autoscaling" {
  source                   = "../../modules/autoscaling"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  vpc_zone_identifier       = var.vpc_zone_identifier
  launch_template_id        = module.launch_template.launch_template_id
  target_group_arns         = var.target_group_arns
  tags                      = var.tags
  termination_policies      = var.termination_policies
}
