variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = map(any)
  default     = {}
}