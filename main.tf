# AWS configuration
provider "aws" {
  access_key = "${length(var.aws["access_key"]) > 1 ? var.aws["access_key"] : ""}"
  profile    = "${length(var.aws["profile"]) > 1 ? var.aws["profile"] : ""}"
  secret_key = "${length(var.aws["secret_key"]) > 1 ? var.aws["secret_key"] : ""}"
  region     = "${length(var.aws["region"]) > 1 ? var.aws["region"] : ""}"
}

# Cloud init user data
data "template_file" "user_data" {
  count    = "${var.instance["count"]}"
  template = "${file("${path.module}/files/cloud_cfg.tpl")}"

  vars {
    domain        = "${var.domain}"
    fqdn          = "${var.hostname}.${var.domain}"
    hostname      = "${var.hostname}"
    init_hostname = "true"
    init_hosts    = "false"
    init_resolv   = "false"
  }
}

# Provision server
resource "aws_instance" "vormetric" {
  ami                         = "${var.instance["ami"]}"
  associate_public_ip_address = "${var.instance["public"]}"
  count                       = "${var.instance["count"]}"
  instance_type               = "${var.instance["type"]}"
  key_name                    = "${var.instance["key_name"]}"
  subnet_id                   = "${var.network["private"]}"
  user_data                   = "${data.template_file.user_data.rendered}"
  vpc_security_group_ids      = "${var.instance["sg"]}"

  lifecycle {
    ignore_changes = [
      "associate_public_ip_address",
      "user_data"
    ]
  }

  root_block_device = {
    delete_on_termination = "true"
  }

  tags = {
    Name             = "${var.instance["hostname"]}.${var.instance["domain"]}"
    Description      = "Created using Terraform"
    Ethereum         = "true"
    Terraform        = "true"
    Wallet           = "${var.ethereum["wallet"]}"
  }

  # Prepare system
  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "curl -kL '${var.cuda["pkg_url"]}' -o /tmp/cuda_file.${var.cuda["pkg_ext"]}",
      "sudo ${var.cuda["pkg_ins"]} /tmp/cuda_file.${var.cuda["pkg_ext"]}",
      "rm -rf /tmp/cuda_file.${var.cuda["pkg_ext"]}",
      "sudo ${var.cuda["os_update"]}",
      "sudo ${var.cuda["os_install"]} ${cuda["kernel_pkg"]} cuda ",
      "sudo reboot",
    ]
  }

  # geth and ethminer
  provisioner "remote-exec" {
    inline = [
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "",
    ]
  }

}

