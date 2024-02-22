data "alicloud_vpc" "ack_vpc" {
  vpc_id = resource.alicloud_vpc.ack_vpc.id
  status = "Available"
}
