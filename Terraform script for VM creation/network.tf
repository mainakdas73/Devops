# This is the Final Network file before Ansible configuration.

####################################
# Virtual Network
####################################
resource "azurerm_virtual_network" "vnet" {
  name                = "ansible-vnet"
  address_space       = ["20.20.20.0/24"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

####################################
# Subnet
####################################
resource "azurerm_subnet" "subnet" {
  name                 = "ansible-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["20.20.20.0/25"]
}

####################################
# Network Security Group
####################################
resource "azurerm_network_security_group" "nsg" {
  name                = "ansible-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

####################################
# Public IPs
####################################
resource "azurerm_public_ip" "pip" {
  count               = 3
  name                = "ansible-pip-${count.index + 1}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

####################################
# Network Interfaces
####################################
resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "ansible-nic-${count.index + 1}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

####################################
# NSG Association
####################################
resource "azurerm_network_interface_security_group_association" "assoc" {
  count                     = 3
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}