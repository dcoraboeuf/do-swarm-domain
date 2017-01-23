# Floating IP
output "swarm_ip" {
  value = "${digitalocean_floating_ip.docker_swarm_floating_ip.ip_address}"
}

# Swarm user
output "swarm_user" {
  value = "${var.do_user}"
}
