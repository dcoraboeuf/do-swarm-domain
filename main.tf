##################################################################################################################
# Digital Ocean provider
##################################################################################################################

provider "digitalocean" {
  token = "${var.do_token}"
}

##################################################################################################################
# DO Swarm module
##################################################################################################################

module "do_swarm" {
   source = "github.com/nemerosa/do-swarm"
   do_token = "${var.do_token}"
   do_region = "${var.do_region}"
   do_image = "${var.do_image}"
   do_agent_size = "${var.do_agent_size}"
   do_ssh_key_public = "${var.do_ssh_key_public}"
   do_ssh_key_private = "${var.do_ssh_key_private}"
   do_user = "${var.do_user}"
   swarm_name = "${var.swarm_name}"
   swarm_master_count = "${var.swarm_master_count}"
   swarm_agent_count = "${var.swarm_agent_count}"
}

##################################################################################################################
# Floating IP
##################################################################################################################

resource "digitalocean_floating_ip" "docker_swarm_floating_ip" {
  droplet_id = "${module.do_swarm.swarm_primary_droplet_id}"
  region = "${var.do_region}"
}

##################################################################################################################
# DO Domain
##################################################################################################################

resource "digitalocean_record" "docker_swarm_dns_record_floating_ip" {
  domain = "${var.dns_domain}"
  type = "A"
  name = "${var.dns_domain_name}"
  value = "${digitalocean_floating_ip.docker_swarm_floating_ip.ip_address}"
}

resource "digitalocean_record" "docker_swarm_dns_record_primary" {
  domain = "${var.dns_domain}"
  type = "A"
  name = "${var.dns_domain_name}"
  value = "${module.do_swarm.swarm_ip}"
}

resource "digitalocean_record" "docker_swarm_dns_record_other" {
  count = "${var.swarm_master_count}"
  domain = "${var.dns_domain}"
  type = "A"
  name = "${var.dns_domain_name}"
  value = "${module.do_swarm.swarm_ips[count.index]}"
}
