output "logtail_config_list" {
  value = concat(
    [
      for conf in alicloud_logtail_config.logtail_config_common : conf.name
    ],
    [
      for conf in alicloud_logtail_config.logtail_config_json : conf.name
    ],
    [
      for conf in alicloud_logtail_config.logtail_config_metrics : conf.name
    ]
  )
}

