terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.40.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.2.2"
    }
  }
  required_version = ">= 0.13"

  backend "swift" {
    container = "terraform-state-ntua"
    cloud     = "openstack"
  }
}

provider "openstack" {
  cloud       = "openstack"
  use_octavia = true
}

provider "rke" {
}
