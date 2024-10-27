# Déclaration du fournisseur
provider "azurerm" {
  features {}
}

# Création du Groupe de Ressources
resource "azurerm_resource_group" "rg" {
  name     = "rg-restoproch"
  location = "West Europe"
}

# Configuration du Réseau
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-restoproch"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Création des Sous-Réseaux
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

# Création des Machines Virtuelles pour le Backend et le Frontend
# Création du modèle pour les VM backend
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

# Création du modèle pour les VM frontend
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

# Mise en place du Load Balancer
# Load Balancer pour les VM Backend
resource "azurerm_lb" "lb_back" {
  name                = "lb-back"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  frontend_ip_configuration {
    name                 = "PublicIPAddressBack"
    public_ip_address_id = azurerm_public_ip.pip_back.id
  }
}

# Load Balancer pour les VM Frontend
resource "azurerm_lb" "lb_front" {
  name                = "lb-front"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  frontend_ip_configuration {
    name                 = "PublicIPAddressFront"
    public_ip_address_id = azurerm_public_ip.pip_front.id
  }
}
