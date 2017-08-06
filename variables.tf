variable "aws_region" {
  default = "us-west-2"
}

variable "aws_profile" {
  description = "Name of AWS profile to use for API access."
  default     = "default"
}

variable "vpc_cidr" {
  description = "CIDR for build VPC"
  default     = "192.168.0.0/16"
}

variable "project" {
  description = "Default value for project tag."
  default     = "foodcart"
}

variable "slack_webhook" {
  description = "Slack incoming webhook to use for posting."
}
