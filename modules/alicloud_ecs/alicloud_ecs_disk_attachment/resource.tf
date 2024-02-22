resource "alicloud_ecs_disk_attachment" "ecs_disk_attachment" {
  for_each    = var.ecs_disk_mapping
  disk_id     = each.value.disk_id
  instance_id = each.value.node_id
}
