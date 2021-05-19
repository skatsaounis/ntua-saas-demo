resource "openstack_compute_keypair_v2" "ssh_keypair" {
  name       = "kubernetes-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "template_cloudinit_config" "kubernetes_user_data" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.kubernetes_init.rendered
  }
}

data "template_file" "kubernetes_init" {
  template = file("${path.module}/templates/init.sh.tpl")

  vars = {

  }
}

resource "openstack_compute_instance_v2" "kubernetes_host" {
  name            = "demo-k8s"
  image_name      = "Ubuntu 20.04"
  flavor_name     = "Gray"
  key_pair        = openstack_compute_keypair_v2.ssh_keypair.name
  security_groups = ["default", openstack_compute_secgroup_v2.net_secgroup.name]
  user_data       = data.template_cloudinit_config.kubernetes_user_data.rendered

  network {
    uuid = openstack_networking_network_v2.private_net.id
  }
}

resource "null_resource" "wait_init" {
  triggers = {
    kubernetes_host_id = openstack_compute_instance_v2.kubernetes_host.id
  }

  depends_on = [openstack_compute_floatingip_associate_v2.host_assoc_fip]

  provisioner "remote-exec" {
    connection {
      host        = openstack_networking_floatingip_v2.host_public_ip.address
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }

    inline = [
      "cloud-init status --wait",
      "sleep 30"
    ]
  }
}
