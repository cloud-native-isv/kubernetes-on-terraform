output "ecs_instances" {
  value = {
    for ecs in data.alicloud_instances.ecs_instances.instances : ecs.id => ecs
  }
}
