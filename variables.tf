variable "region" {
  type        = string
  description = "The region to deploy all resources"
  default     = "eu-west-1"
}

variable "environment" {
  type        = string
  description = "Name for the testing environment"
  default     = "test"
}

variable "ami_id" {
  type        = string
  description = "An AMI ID to use for the instance"
  default     = "ami-0978f2d57755c6503"
}

variable "instance_name" {
  type        = string
  description = "Name for the instance and tag"
  default     = "instance"
}

variable "instance_size" {
  type        = string
  description = "Size of instance to use for build"
  default     = "t3.small"
}

variable "port" {
  type        = number
  description = "Port to allow traffic from"
  default     = 8080
}

variable "cidr_blocks" {
  type        = list(string)
  description = "list of cidr blocks for security group rules"
  default     = ["172.31.0.0/16"]
}
