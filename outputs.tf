output "vpc_id" {
  value = aws_default_vpc.default.id
}


output "instance_id" {
  value = aws_instance.testing_instance.id
}

output "sg_id" {
  value = aws_security_group.security_group.id
}

output "sg_total_ingress" {
  value = length(aws_security_group.security_group.ingress)

}
