

########################
# Initialize Provider  #
########################

provider "openstack" {
  auth_url = "${var.identity}"
  tenant_name = "${var.tenant_name}"
  user_name = "${var.username}"
  password = "${var.password}"
}

########################
# Creating floating IP #
########################

#OpsManager
resource "openstack_compute_floatingip_v2" "floatip_opsman" {
  region = "${var.region}"
  pool = "${var.floating_ip_pool}"
}



# HaProxy if required"
resource "openstack_compute_floatingip_v2" "floatip_haproxy" {
  region = "${var.region}"
  pool = "${var.floating_ip_pool}"
}



#############################
# Creating PCF network      #
#############################
#1. Create new network

resource "openstack_networking_network_v2" "pcf_internal" {
  name = "pcf_internal"
  admin_state_up = "true"
}

#2. Create subnet`
resource "openstack_networking_subnet_v2" "pcf_internal_subnet" {
  network_id = "${openstack_networking_network_v2.pcf_internal.id}"
  cidr = "${var.network}.199.0/24"
  ip_version = 4
}

#3. Create new router
#resource "openstack_networking_router_v2" "router_pcf" {
#  region = "{var.region}"
#  name = "router_pcf"
#  external_gateway = "f67f0d72-0ddf-11e4-9d95-e1f29f417e2f"
#}


#4. Create interface Internal / External
resource "openstack_networking_router_interface_v2" "interface_router_pcf" {
  region = "${var.region}"
  #router_id = "${openstack_networking_router_v2.router_pcf.id}"
  router_id = "ad6b760b-3611-4597-895e-c918c9e5d228"
  subnet_id = "${openstack_networking_subnet_v2.pcf_internal_subnet.id}"
}


###################
# Security Groups #
###################

resource "openstack_compute_secgroup_v2" "cf" {
  name = "cf"
  description = "Cloud Foundry Security groups"
  region = "${var.region}"

  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port = "80"
    to_port = "80"
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port = "443"
    to_port = "443"
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port = "4443"
    to_port = "4443"
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port = "4222"
    to_port = "25777"
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    self = true
  }

  rule {
    ip_protocol = "tcp"
    from_port = "1"
    to_port = "65535"
    self = true
  }

  rule {
    ip_protocol = "udp"
    from_port = "1"
    to_port = "65535"
    self = true
  }

}


