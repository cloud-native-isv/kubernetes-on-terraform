data "alicloud_ecs_network_interfaces" "by_id" {
  ids = var.interface_ids
}

data "alicloud_ecs_network_interfaces" "by_name" {
  name_regex = var.interface_name_regex
}
