variable "region" {
  type = string
}

variable "log_project" {
  type = string
}

variable "machine_group" {
  type = string
}

variable "logtail_config_list" {
  type = list(string)
}
