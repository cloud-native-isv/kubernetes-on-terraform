resource "alicloud_ecs_invocation" "ecs_invocation" {
  command_id  = var.command_id
  instance_id = var.instance_ids
  repeat_mode = "Once"
  timeouts {
    create = "10m"
    
  }
}
