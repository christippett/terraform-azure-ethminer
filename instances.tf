# create public IP
resource "azurerm_public_ip" "ether" {
  count                        = "${var.instance_count}"
  name                         = "${var.prefix}${format("%02d", count.index + 1)}-ip"
  location                     = "${var.region}"
  resource_group_name          = "${azurerm_resource_group.ether.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "${var.prefix}${format("%02d", count.index + 1)}-${substr(random_id.key.hex, 0, 8)}"

  lifecycle {
    ignore_changes = [
      "domain_name_label",
    ]
  }
}

# create network interface
resource "azurerm_network_interface" "ether" {
  count               = "${var.instance_count}"
  name                = "${var.prefix}${format("%02d", count.index + 1)}-nic"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.ether.name}"

  ip_configuration {
    name                          = "${var.prefix}${format("%02d", count.index + 1)}-ipconfig"
    subnet_id                     = "${azurerm_subnet.ether.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost(var.subnet_cidr, (count.index + 1) * 10)}"
    public_ip_address_id          = "${element(azurerm_public_ip.ether.*.id, count.index)}"
  }
}

# create virtual machine
resource "azurerm_virtual_machine" "ether" {
  count                 = "${var.instance_count}"
  name                  = "${var.prefix}${format("%02d", count.index + 1)}"
  location              = "${var.region}"
  resource_group_name   = "${azurerm_resource_group.ether.name}"
  network_interface_ids = ["${element(azurerm_network_interface.ether.*.id, count.index)}"]
  vm_size               = "Standard_NC6"                                                    # Standard_A0
  depends_on            = ["azurerm_storage_container.ether"]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.prefix}vm-disk"
    vhd_uri       = "${azurerm_storage_account.ether.primary_blob_endpoint}${azurerm_storage_container.ether.name}/${var.prefix}${format("%02d", count.index + 1)}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = 512
  }

  os_profile {
    computer_name  = "${var.prefix}${format("%02d", count.index + 1)}"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${var.ssh_key}"
    }
  }

  provisioner "remote-exec" {
    script = "bootstrap.sh"

    connection {
      type        = "ssh"
      host        = "${element(azurerm_public_ip.ether.*.fqdn, count.index)}"
      user        = "azureuser"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}
