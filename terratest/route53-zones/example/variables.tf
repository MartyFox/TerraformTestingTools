variable "public_zones" {
  description = "Map of Route53 public zone parameters"
  type        = map(any)
  default     = {}
}

### Example code for zones
# {
#   "r53example.org" = {
#     comment = "r53example.org public zone"
#     tags = {
#       Name = "r53example.org"
#     }
#   }
# }

variable "private_zones" {
  description = "Map of Route53 private zone parameters"
  type        = map(any)
  default     = {}
}

### Example code for zones
# {
#   "r53example.aws.local" = {
#     comment = "r53example private zone"
#     vpc = ["vpc-1234"]
#     tags = {
#       Name = "r53example.aws.local"
#     }
#   }
# }