module "network" {
  source              = "Azure/vnet/azurerm"
  version             = "2.4.0"
  vnet_name           = "vnet-${var.company}-${var.project}-gui"
  resource_group_name = azurerm_resource_group.compose_resource_group.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  nsg_ids = {
    subnet1 = azurerm_network_security_group.compose_secuirity_group.id
  }

  tags = {
    environment = var.environment
  }

  depends_on = [azurerm_resource_group.compose_resource_group]
}