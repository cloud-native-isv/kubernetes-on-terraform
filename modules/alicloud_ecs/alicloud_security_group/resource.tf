resource "alicloud_security_group" "default" {
  vpc_id = var.vpc_id
  resource_group_id = var.resource_group_id
}