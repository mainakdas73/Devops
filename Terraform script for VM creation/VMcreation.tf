resource "azurerm_linux_virtual_machine" "vm" {
  count               = 3
  name                = "ansible-vm-mainak${count.index + 1}"
  computer_name       = "ansible${count.index + 1}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_B1s"

  admin_username = "docker"
  admin_password = "Docker@12345"

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  disable_password_authentication = false

  admin_ssh_key {
    username   = "docker"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
