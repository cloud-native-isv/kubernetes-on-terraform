resource "terraform_data" "run_04-setup-remote-files" {

  provisioner "local-exec" {
    command     = "bash ${path.module}/script/04-setup-remote-files.sh ${var.prefix} ${var.public_key_file}"
    working_dir = var.working_dir
  }
}

resource "terraform_data" "run_05-get-remote-ssh-config" {
  for_each = module.alicloud_instance.instance_map

  provisioner "local-exec" {
    command     = "bash ${path.module}/script/05-get-remote-ssh-config.sh ${each.key} ${each.value.public_ip}"
    working_dir = var.working_dir
  }

  depends_on = [resource.terraform_data.run_04-setup-remote-files]
}

resource "terraform_data" "run_07-download-kubeconfig" {
  for_each = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  provisioner "local-exec" {
    command = join(";", [
      "bash ${path.module}/script/06-wait-nodes-ready.sh ${each.key} 600",
      "bash ${path.module}/script/07-download-kubeconfig.sh ${each.value.private_ip} ${each.value.public_ip}"
    ])
    working_dir = var.working_dir
  }

  triggers_replace = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  input = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  depends_on = [resource.terraform_data.run_05-get-remote-ssh-config]
}

resource "terraform_data" "run_08-join-k8s-node" {
  for_each = { for k, v in module.alicloud_instance.instance_map : k => v if k != "k8s-control" }

  provisioner "local-exec" {
    command = join(";", [
      "bash ${path.module}/script/06-wait-nodes-ready.sh ${each.key} 600",
      "bash ${path.module}/script/08-join-k8s-node.sh ${each.key}"
    ])
    working_dir = var.working_dir
  }

  depends_on = [resource.terraform_data.run_07-download-kubeconfig]
}

resource "terraform_data" "run_09-update-control-cert" {
  for_each = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  provisioner "local-exec" {
    command = join(";", [
      "bash ${path.module}/script/06-wait-nodes-ready.sh ${each.key} 600",
      "bash ${path.module}/script/09-update-control-cert.sh ${each.key} ${each.value.private_ip} ${each.value.public_ip}"
    ])
    working_dir = var.working_dir
  }

  triggers_replace = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  input = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  depends_on = [resource.terraform_data.run_08-join-k8s-node]
}

resource "terraform_data" "run_apply_k8s_manifest" {
  for_each = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  provisioner "local-exec" {
    command = join(";", [
      "bash ${path.module}/script/10-wait-controls-ready.sh ${each.key} 600",
      "kubectl apply -R -f ${var.working_dir}/kube/manifest"
    ])
    working_dir = var.working_dir
    environment = {
      KUBECONFIG = "${var.working_dir}/kube/config.yaml"
    }
  }
  triggers_replace = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  input = { for k, v in module.alicloud_instance.instance_map : k => v if k == "k8s-control" }

  depends_on = [resource.terraform_data.run_09-update-control-cert]
}
