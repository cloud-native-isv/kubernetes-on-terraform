resource "alicloud_ecs_command" "ecs_command" {
  name            = var.name
  command_content = base64encode(join("\n", var.script))
  type            = "RunShellScript"
  working_dir     = var.workdir
  timeout         = 600
}
