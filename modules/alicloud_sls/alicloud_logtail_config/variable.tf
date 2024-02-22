variable "log_project" {
  type = string
}

variable "log_store_map" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "common_log_map" {
  type = map(object({
    file_path    = string
    file_pattern = string
    key          = list(string)
    regex        = string
  }))

  default = {}
}

variable "json_log_map" {
  type = map(object({
    file_path    = string
    file_pattern = string
  }))

  default = {}
}

variable "metrics_log_map" {
  type = map(object({
    job_name = string
    targets  = list(string)
  }))

  default = {}
}
