resource "alicloud_ecs_disk" "ecs_disks" {
  for_each             = var.ecs_disk_mapping
  disk_name            = each.key
  category             = var.ecs_disk_category
  delete_with_instance = false
  payment_type         = "PayAsYouGo"
  zone_id              = each.value.zone_id
  size                 = each.value.size_in_gb
}
