provider "aws" {
}

module "public_zones" {
  source = "../"

  zones = var.public_zones
}

module "private_zones" {
  source = "../"

  zones = var.private_zones
}
