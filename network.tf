resource "openstack_networking_network_v2" "private_net" {
  name           = "private-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "private-subnet"
  network_id      = openstack_networking_network_v2.private_net.id
  cidr            = "20.0.0.0/16"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_networking_router_v2" "net_router" {
  name                = "net-router"
  admin_state_up      = "true"
  external_network_id = data.openstack_networking_network_v2.os_extnet.id
}

resource "openstack_networking_router_interface_v2" "private_net_router_iface" {
  router_id = openstack_networking_router_v2.net_router.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}

resource "openstack_compute_secgroup_v2" "net_secgroup" {
  name        = "net_secgroup"
  description = "Kubernetes security group with sane rules"

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 2379
    to_port     = 2379
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 10250
    to_port     = 10250
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 6443
    to_port     = 6443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_floatingip_v2" "host_public_ip" {
  pool = "FloatingIP-Network"
}

resource "openstack_compute_floatingip_associate_v2" "host_assoc_fip" {
  floating_ip = openstack_networking_floatingip_v2.host_public_ip.address
  instance_id = openstack_compute_instance_v2.kubernetes_host.id
}
