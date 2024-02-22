resource "alicloud_vpc" "k8s_vpc" {
  description       = "vpc for test kangaroo related resources in ${var.region}"
  cidr_block        = "10.0.0.0/8"
  vpc_name          = "${var.vpc_prefix}-${var.region}"
  enable_ipv6       = false
  resource_group_id = var.resource_group_id
}
