resource "alicloud_eip_association" "default" {
  for_each      = zipmap(var.ecs_ids, var.eip_ids)
  instance_id   = each.key
  allocation_id = each.value
}
