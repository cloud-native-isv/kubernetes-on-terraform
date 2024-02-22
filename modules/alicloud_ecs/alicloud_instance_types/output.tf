output "ecs_types" {
  value = [for type in data.alicloud_instance_types.ecs_instance_type.instance_types : type]
}
