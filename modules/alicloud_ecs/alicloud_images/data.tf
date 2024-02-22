data "alicloud_images" "ecs_images" {
  owners       = "system"
  os_type      = "linux"
  architecture = "x86_64"
  name_regex   = var.name_regex
}
