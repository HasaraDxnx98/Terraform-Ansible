# Creates a resource group in the Azure
resource "azurerm_resource_group" "compose_resource_group" {
  name     = "rg-${var.company}-${var.project}"
  location = var.location
}

# Creates a network security group within the resource group
resource "azurerm_network_security_group" "compose_secuirity_group" {
  name                = "sg-${var.company}-${var.project}"
  resource_group_name = azurerm_resource_group.compose_resource_group.name
  location            = azurerm_resource_group.compose_resource_group.location

  dynamic "security_rule" {
    for_each = var.security_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

}

# Creates a public IP address within the resource group
resource "azurerm_public_ip" "compose_public_ip" {
  name                = "ip-${var.company}-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.compose_resource_group.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.environment
  }

  depends_on = [azurerm_resource_group.compose_resource_group]
}

# -------------------------------- VM Instance - Instance 01 ---------------------------------------------------

# Creates a network interface within the resource group
resource "azurerm_network_interface" "GUI_network_interface" {
  name                = "nic-${var.company}-${var.project}-gui"
  location            = azurerm_resource_group.compose_resource_group.location
  resource_group_name = azurerm_resource_group.compose_resource_group.name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.100"
    subnet_id                     = module.network.vnet_subnets[0]
    public_ip_address_id          = azurerm_public_ip.compose_public_ip.id
  }

  depends_on = [azurerm_resource_group.compose_resource_group]
}

#  Creates a Linux virtual machine within the resource group
resource "azurerm_linux_virtual_machine" "GUI_virtual_machine" {
  size                = var.instance_size_B4als
  name                = "vm-${var.company}-${var.project}-gui"
  resource_group_name = azurerm_resource_group.compose_resource_group.name
  location            = azurerm_resource_group.compose_resource_group.location
  custom_data         = filebase64("scripts/init.tpl")
  network_interface_ids = [
    azurerm_network_interface.GUI_network_interface.id,
  ]

  # Define the image file 
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8_8"
    version   = "latest"
  }

  computer_name  = "sampleuser"
  admin_username = var.username
  admin_password = var.password
  disable_password_authentication = false

  os_disk {
    name                 = "dsk-${var.company}-${var.project}-gui"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

    provisioner "file" {
    connection {
      type     = "ssh"
      host     = self.public_ip_address
      user     = var.username
      password = var.password
    }
    source      = "ansible/ansible_book.yml"
    destination = "/tmp/ansible_book.yml"
  }


  tags = {
    environment = var.environment
  }

  depends_on = [azurerm_resource_group.compose_resource_group]
}

# Create the Managed Disk for vm instance
resource "azurerm_managed_disk" "GUI_data_disk" {
  name                 = "datadsk-${var.company}-${var.project}-gui"
  location             = azurerm_linux_virtual_machine.GUI_virtual_machine.location
  resource_group_name  = azurerm_linux_virtual_machine.GUI_virtual_machine.resource_group_name
  storage_account_type = "Premium_LRS" 
  create_option        = "Empty"       
  disk_size_gb         = 128
  tags = {
    environment = var.environment
  }
}

# Attach the data disk to the vm Instance
resource "azurerm_virtual_machine_data_disk_attachment" "attach_GUI_data_disk" {
  virtual_machine_id = azurerm_linux_virtual_machine.GUI_virtual_machine.id
  managed_disk_id    = azurerm_managed_disk.GUI_data_disk.id
  lun                = 1 
  caching            = "ReadWrite"
}

# Remotely execute the ansible play book in the VM
resource "null_resource" "Remote_exe_VM01" {
  connection {
    type     = "ssh"
    host     = azurerm_linux_virtual_machine.GUI_virtual_machine.public_ip_address
    user     = var.username
    password = var.password
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sleep 180s",
      "sudo ansible-playbook /tmp/ansible_book.yml",
    ]
  }
  depends_on = [ azurerm_linux_virtual_machine.GUI_virtual_machine ]

}
