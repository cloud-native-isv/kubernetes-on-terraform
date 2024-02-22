output "log_store_name" {
  value = alicloud_log_store.log_store.logstore_name
}

output "metric_store_name" {
  value = alicloud_log_store.metric_store.logstore_name
}
