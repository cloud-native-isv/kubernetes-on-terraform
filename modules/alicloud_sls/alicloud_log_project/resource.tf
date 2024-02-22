resource "alicloud_log_project" "log_project" {
  project_name      = var.project_name
  resource_group_id = var.resource_group_id
}
