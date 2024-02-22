# ECS Instance Resource for Module
resource "alicloud_instance" "ecs_instances" {
  for_each = var.instances

  vswitch_id                 = each.value.vswitch_id
  security_groups            = var.security_groups
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  image_id                   = each.value.image_id
  instance_type              = each.value.instance_type
  instance_name              = each.key
  resource_group_id          = var.resource_group_id
  host_name                  = each.key
  key_name                   = var.key_pair_name

  system_disk_category = var.new_ecs_template.system_disk_category
  system_disk_size     = var.new_ecs_template.system_disk_size

  user_data = base64encode(join("\n", each.value.init_scripts))

  dynamic "data_disks" {
    for_each = var.data_disks
    content {
      name                    = lookup(data_disks.value, "name", "data")
      size                    = lookup(data_disks.value, "size", 500)
      category                = lookup(data_disks.value, "category", "cloud_essd")
      encrypted               = lookup(data_disks.value, "encrypted", null)
      snapshot_id             = lookup(data_disks.value, "snapshot_id", null)
      delete_with_instance    = lookup(data_disks.value, "delete_with_instance", null)
      description             = lookup(data_disks.value, "description", null)
      auto_snapshot_policy_id = lookup(data_disks.value, "auto_snapshot_policy_id", null)
    }
  }
}
