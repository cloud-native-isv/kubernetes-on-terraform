variable "region" {
  type = string
}

variable "vpc_name" {
  type = string

  default = "ack_vpc"
}

variable "cidr_block" {
  type = string

  default = "10.0.0.0/8"
}
