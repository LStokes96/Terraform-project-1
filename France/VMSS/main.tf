resource "azurerm_virtual_network" "France-VN" {
  name                = "france_vn"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = ["10.0.0.0/16"]
  tags                = var.resource_group_tags
}

resource "azurerm_subnet" "France-SUB" {
  name                 = "france-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.France-VN.name
  address_prefix       = "10.0.2.0/24"
  tags                 = var.resource_group_tags
}

resource "azurerm_linux_virtual_machine_scale_set" "France-VMSS" {
  name                = "france-vmss"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard_F2"
  instances           = 3
  admin_username      = "adminuser"
  tags                = var.resource_group_tags

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.France-SUB.id
    }
  }
}