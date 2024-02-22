output "ecs_disk_mapping" {
  # this output add a disk id to input variable
  value = {
    for disk in alicloud_ecs_disk.ecs_disks : disk.disk_name => {
      disk_id = disk.id
      node_id = var.ecs_disk_mapping[disk.disk_name].node_id
    }
  }
}

