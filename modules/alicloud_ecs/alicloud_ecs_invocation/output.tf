output "invocation_id" {
  value = resource.alicloud_ecs_invocation.ecs_invocation.id
}

output "invocation_status" {
  value = resource.alicloud_ecs_invocation.ecs_invocation.status
}
