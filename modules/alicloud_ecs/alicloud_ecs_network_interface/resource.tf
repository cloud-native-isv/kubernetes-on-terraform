resource "alicloud_ecs_network_interface" "k8s_ecs_network_interface" {
  for_each               = var.interface_mapping
  network_interface_name = each.key
  vswitch_id             = var.vswitches_mapping[each.value.zone_id].id
  security_group_ids     = each.value.security_group_ids
}
