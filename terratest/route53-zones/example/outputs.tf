output "public_zones_zoneids" {
  value = module.public_zones.this_route53_zone_zone_ids
}

output "public_zones_nameservers" {
  value = module.public_zones.this_route53_zone_name_servers
}

output "private_zones_zoneids" {
  value = module.private_zones.this_route53_zone_zone_ids
}

output "private_zones_nameservers" {
  value = module.private_zones.this_route53_zone_name_servers
}
