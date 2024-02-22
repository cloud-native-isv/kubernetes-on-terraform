variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "script" {
  type = list(string)
}

variable "workdir" {
  type = string

  default = "/root"
}
