output "server_private_ip" {
  value = azurerm_linux_virtual_machine.GUI_virtual_machine.private_ip_address
}

output "server_public_ip" {
  value = azurerm_linux_virtual_machine.GUI_virtual_machine.public_ip_address
}