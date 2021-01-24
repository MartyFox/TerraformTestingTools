resource "aws_route53_zone" "this" {
  for_each = var.zones

  name          = each.key
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  dynamic "vpc" {
    for_each = lookup(each.value, "vpc", null) == null ? [] : [each.value.vpc]
    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    map(
      "Terraform", "true",
    ),
    lookup(each.value, "tags", null)
  )
}
