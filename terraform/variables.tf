variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "admin_cidr" {
  description = "Public IP address allowed to SSH into the web server"
  type        = string
}
