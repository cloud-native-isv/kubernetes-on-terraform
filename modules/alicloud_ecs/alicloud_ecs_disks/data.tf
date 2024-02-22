data "alicloud_ecs_disks" "by_id" {
  ids = var.disk_ids
}

data "alicloud_ecs_disks" "by_name" {
  name_regex = var.disk_name_regex
}
