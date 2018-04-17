output "public_ip_addresses" {
  value = ["${azurerm_public_ip.ether.*.fqdn}"]
}
