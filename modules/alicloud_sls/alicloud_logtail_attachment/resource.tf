resource "alicloud_logtail_attachment" "logtail_attachment" {
  for_each            = toset(var.logtail_config_list)
  project             = var.log_project
  logtail_config_name = each.value
  machine_group_name  = var.machine_group
}

