provider "azurerm" {
  subscription_id = "8dfadf4a-268a-449b-b7a3-b288fa49eb40"
}

resource "random_id" "key" {
  byte_length = 8
}

# create a resource group
resource "azurerm_resource_group" "ether" {
  name     = "Ether"
  location = "${var.region}"
}

# create storage account
resource "azurerm_storage_account" "ether" {
  name                     = "${random_id.key.hex}"
  resource_group_name      = "${azurerm_resource_group.ether.name}"
  location                 = "${var.region}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

# create storage container
resource "azurerm_storage_container" "ether" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.ether.name}"
  storage_account_name  = "${azurerm_storage_account.ether.name}"
  container_access_type = "private"
  depends_on            = ["azurerm_storage_account.ether"]
}

# create a virtual network
resource "azurerm_virtual_network" "ether" {
  name                = "${var.prefix}vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.ether.name}"
}

# create subnet
resource "azurerm_subnet" "ether" {
  name                 = "${var.prefix}subnet"
  resource_group_name  = "${azurerm_resource_group.ether.name}"
  virtual_network_name = "${azurerm_virtual_network.ether.name}"
  address_prefix       = "${var.subnet_cidr}"
  depends_on           = ["azurerm_virtual_network.ether"]
}
