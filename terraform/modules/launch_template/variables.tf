variable "template_name" {
  description = "The name of the launch template"
  type        = string
}

variable "image_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type (e.g., t2.micro)"
  type        = string
}

variable "tags" {
  description = "Tags for the launch template"
  type        = map(string)
}
