resource "azurerm_resource_group" "rg" {
name = "myfirstRG1990"
location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
name = "myvnet1"
address_space = ["10.0.0.0/16"]
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
name= "subnet19"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "pip" {
name = "mypublicIP"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
allocation_method = "Static"
}

resource "azurerm_network_interface" "nic" {
name = "myNic"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
 ip_configuration {
 name = "internal"
 subnet_id = azurerm_subnet.subnet.id
 private_ip_address_allocation = "Dynamic"
 public_IP_Address_id = azurerm_public_IP.pip.id
 }
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "myLinuxVM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.nic.id] 

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

   source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
    host        = azurerm_public_ip.pip.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}   




