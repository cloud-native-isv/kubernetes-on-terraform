resource "alicloud_vpc" "ack_vpc" {
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
}
