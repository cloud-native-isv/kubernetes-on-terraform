resource "alicloud_log_store" "log_store" {
  project_name          = var.log_project
  logstore_name         = "${var.name}-logstore"
  retention_period      = 7
  shard_count           = 8
  auto_split            = true
  max_split_shard_count = 64
  append_meta           = true
}

resource "alicloud_log_store" "metric_store" {
  project_name          = var.log_project
  logstore_name         = "${var.name}-metricstore"
  retention_period      = 7
  shard_count           = 8
  auto_split            = true
  max_split_shard_count = 64
  append_meta           = true
  telemetry_type        = "Metrics"
}
