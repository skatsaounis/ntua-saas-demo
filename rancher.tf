resource "rke_cluster" "kubernetes_demo" {
  nodes {
    address = openstack_networking_floatingip_v2.host_public_ip.address
    user    = "ubuntu"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  depends_on = [null_resource.wait_init]
}

resource "local_file" "kube_cluster_yaml" {
  filename          = "${path.root}/kube_config_cluster.yml"
  file_permission   = "0644"
  sensitive_content = rke_cluster.kubernetes_demo.kube_config_yaml
}
