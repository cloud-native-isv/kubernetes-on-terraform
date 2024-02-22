output "ecs_disks" {
  value = merge(
    {
      for disk in data.alicloud_ecs_disks.by_id.disks : disk.id => disk
    },
    {
      for disk in data.alicloud_ecs_disks.by_name.disks : disk.id => disk
    }
  )
}

