variable "region" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "visitor_ip_list" {
  type = list(string)
}
