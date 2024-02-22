output "instance_ids" {
  value = [
    for k, v in alicloud_instance.ecs_instances : v.id
  ]
}

output "instance_map" {
  value = {
    for k, v in alicloud_instance.ecs_instances : v.instance_name => v
  }
}
