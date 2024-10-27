# Fournisseur Azure
provider "azurerm" {
  features {}
  
  subscription_id = "6c46b4a5-11a4-41b7-b219-51cf755d4529"

}

# Création du groupe de ressources
resource "azurerm_resource_group" "rg" {
  name     = "rg-restoproch"
  location = "West Europe"
}

# Création du réseau virtuel
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-restoproch"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Création des sous-réseaux pour backend et frontend
resource "azurerm_subnet" "subnet_back" {
  name                 = "subnet-backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet_front" {
  name                 = "subnet-frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Interfaces réseau pour les machines virtuelles backend
resource "azurerm_network_interface" "nic_back" {
  count               = 2
  name                = "nic-back-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet_back.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Interfaces réseau pour les machines virtuelles frontend
resource "azurerm_network_interface" "nic_front" {
  count               = 2
  name                = "nic-front-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet_front.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Création des machines virtuelles backend
resource "azurerm_linux_virtual_machine" "vm_back" {
  count               = 2
  name                = "back-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic_back[count.index].id
  ]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Création des machines virtuelles frontend
resource "azurerm_linux_virtual_machine" "vm_front" {
  count               = 2
  name                = "front-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic_front[count.index].id
  ]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Création du Load Balancer pour les machines backend
resource "azurerm_public_ip" "pip_back" {
  name                = "pip-back"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"  # Changement vers Static
  sku                 = "Standard"
}

resource "azurerm_lb" "lb_back" {
  name                = "lb-back"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddressBack"
    public_ip_address_id = azurerm_public_ip.pip_back.id
  }
}

# Création du Load Balancer pour les machines frontend
resource "azurerm_public_ip" "pip_front" {
  name                = "pip-front"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"  # Changement vers Static
  sku                 = "Standard"
}

resource "azurerm_lb" "lb_front" {
  name                = "lb-front"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddressFront"
    public_ip_address_id = azurerm_public_ip.pip_front.id
  }
}
