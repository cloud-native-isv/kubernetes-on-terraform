resource "alicloud_log_store_index" "log_store_index" {
  project  = var.log_project
  logstore = var.log_store
  full_text {
    case_sensitive = true
    token          = " +,;:\"#$%^*\r\n\t"
  }
  field_search {
    name             = "__tag__:__user_defined_id__"
    alias            = "cluster"
    enable_analytics = true
    case_sensitive   = true
    type             = "text"
    token            = " +,;:\"#$%^*\r\n\t"
  }
  field_search {
    name             = "__tag__:__hostname__"
    alias            = "host"
    enable_analytics = true
    case_sensitive   = true
    type             = "text"
    token            = " +,;:\"#$%^*\r\n\t"
  }
  field_search {
    name             = "__tag__:_node_name_"
    alias            = "node"
    enable_analytics = true
    case_sensitive   = true
    type             = "text"
    token            = " +,;:\"#$%^*\r\n\t"
  }
    field_search {
    name             = "__raw_log__"
    alias            = "raw_log"
    enable_analytics = true
    case_sensitive   = true
    type             = "text"
    token            = " +,;:\"#$%^*\r\n\t"
  }
  field_search {
    name             = "msg"
    enable_analytics = true
    case_sensitive   = true
    type             = "text"
    token            = " +,;:\"#$%^*\r\n\t"
  }
  field_search {
    name             = "level"
    enable_analytics = true
    case_sensitive   = true
    type             = "text"
    token            = " +,;:\"#$%^*\r\n\t"
  }
  field_search {
    name             = "ts"
    enable_analytics = true
    case_sensitive   = true
    type             = "text"
    token            = " +,;:\"#$%^*\r\n\t"
  }
}

# │ Error: [ERROR] terraform-provider-alicloud/alicloud/resource_alicloud_log_store_index.go:190: Resource alicloud_log_store_index CreateIndex Failed!!! [SDK aliyun-log-go-sdk ERROR]:
# │ {
# │     "httpCode": 501,
# │     "errorCode": "NotImplemented",
# │     "errorMessage": "this method is not implemented for metric store not Implemented yet!",
# │     "requestID": "6560668F728D97DB99AA3746"
# │ }

# resource "alicloud_log_store_index" "alert_metric_store_index" {
#   project  = var.log_project
#   logstore = var.alert_metric_store
#   full_text {
#     case_sensitive = true
#     token          = " +,;:\"#$%^*\r\n\t"
#   }
#   field_search {
#     name             = "__tag__:__labels__"
#     alias            = "labels"
#     enable_analytics = true
#     case_sensitive   = true
#     type             = "text"
#     token            = " +,;:\"#$%^*\r\n\t"
#   }
#   field_search {
#     name             = "__tag__:__value__"
#     alias            = "value"
#     enable_analytics = true
#     case_sensitive   = true
#     type             = "double"
#     token            = " +,;:\"#$%^*\r\n\t"
#   }
#   field_search {
#     name             = "__tag__:__name__"
#     alias            = "name"
#     enable_analytics = true
#     case_sensitive   = true
#     type             = "text"
#     token            = " +,;:\"#$%^*\r\n\t"
#   }
# }

