output "cluster_ip_addrs" {
  value = yandex_compute_instance.server.*.network_interface.0.ip_address
}
