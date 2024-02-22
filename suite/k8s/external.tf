data "external" "my_network" {
  program = ["bash", "${path.module}/script/00-get-my-network.sh"]
  working_dir = var.working_dir
}

data "external" "my_account" {
  program = ["bash", "${path.module}/script/00-get-my-account.sh"]
  working_dir = var.working_dir
}

locals {
  my_network = data.external.my_network.result.network
  my_account = data.external.my_account.result.account
}

