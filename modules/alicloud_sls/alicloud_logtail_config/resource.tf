

resource "alicloud_logtail_config" "logtail_config_common" {
  for_each    = var.common_log_map
  project     = var.log_project
  logstore    = var.log_store_map["log"]
  input_type  = "file"
  name        = "logtail_config_common_${each.key}"
  output_type = "LogService"
  input_detail = jsonencode({
    enableRawLog   = false
    logType        = "common_reg_log"
    logPath        = each.value.file_path
    filePattern    = each.value.file_pattern
    topicFormat    = "default"
    fileEncoding   = "utf8"
    discardUnmatch = true
    key            = each.value.key
    logBeginRegex  = ".*"
    regex          = each.value.regex

    maxDepth = 10
    advanced = {
      force_multiconfig = true
    }
  })
}

resource "alicloud_logtail_config" "logtail_config_json" {
  for_each    = var.json_log_map
  project     = var.log_project
  logstore    = var.log_store_map["log"]
  input_type  = "file"
  name        = "logtail_config_json_${each.key}"
  output_type = "LogService"
  input_detail = jsonencode({
    enableRawLog   = false
    logType        = "json_log"
    logPath        = each.value.file_path
    filePattern    = each.value.file_pattern
    topicFormat    = "default"
    fileEncoding   = "utf8"
    discardUnmatch = false

    maxDepth = 10
    advanced = {
      force_multiconfig = true
    }
  })
}

resource "alicloud_logtail_config" "logtail_config_metrics" {
  for_each    = var.metrics_log_map
  project     = var.log_project
  logstore    = var.log_store_map["metric"]
  input_type  = "plugin"
  name        = "logtail_config_metrics_${each.key}"
  output_type = "LogService"
  input_detail = jsonencode(
    {
      plugin = {
        inputs = [{
          detail = {
            Yaml = yamlencode({
              global = {
                scrape_interval = "30s"
                scrape_timeout  = "10s"
              }
              scrape_configs = [{
                job_name = each.value.job_name
                static_configs = [{
                  targets = each.value.targets
                }]
              }]
            })
          },
          type = "service_prometheus"
        }]
        processors = [
          {
            type = "processor_appender",
            detail = {
              Key        = "__labels__",
              Value      = "|host#$#{{__host__}}|ip#$#{{__ip__}}|user_defined_id#$#{{$ALIYUN_LOGTAIL_USER_DEFINED_ID}}",
              SortLabels = true
            }
          }
        ]
    } }
  )
}


