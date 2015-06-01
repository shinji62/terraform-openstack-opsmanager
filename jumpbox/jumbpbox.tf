

########################
# Initialize Provider  #
########################

provider "openstack" {
  auth_url = "${var.identity}"
  tenant_name = "${var.tenant_name}"
  user_name = "${var.username}"
  password = "${var.password}"
}
 


#############
# JUMPBOX   #
#############

#OpsManager
resource "openstack_compute_floatingip_v2" "floatip_jumpbox" {
  region = "${var.region}"
  pool = "${var.floating_ip_pool}"
}



resource "openstack_compute_secgroup_v2" "jumpbox" {
  name = "jumpbox"
  description = "Jumpbox Security groups"
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

}

resource "openstack_compute_instance_v2" "jumpbox" {
  name = "Jumpbox"
  flavor_id = "${var.flavor_id_jumpbox}"
  image_id = "${var.image_id_jumpbox}"

  key_pair = "Macbook Gwenn"
  floating_ip = "${openstack_compute_floatingip_v2.floatip_jumpbox.address}"
  security_groups = ["${openstack_compute_secgroup_v2.jumpbox.name}"]
  network {
    uuid = "7cb1285b-e081-44f9-b62e-e81e0f6dfddd"
  }
}