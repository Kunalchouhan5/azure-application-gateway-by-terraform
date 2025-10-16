# Resource Group - On-premises   
resource "azurerm_resource_group" "res-g-1" {
  name = var.rg
  location = var.location
}

resource "azurerm_public_ip" "pip" {
  name                = var.public-ip
  resource_group_name = azurerm_resource_group.res-g-1.name
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
  depends_on = [ azurerm_resource_group.res-g-1]
}

# Virtual Network - hub-Vnet
resource "azurerm_virtual_network" "hub-vnet" {
  name                = var.Vnet-name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.res-g-1.name
}

# Virtual Network Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.Subnet-name
  resource_group_name  = azurerm_resource_group.res-g-1.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = var.address_prefixes

  delegation {
    name = "delegation"
    service_delegation {name = "Microsoft.Network/applicationGateways"}
  }
}

# locals {
#   backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
#   frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
#   frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
#   http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
#   listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
#   request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
#   redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
# }


# Application Gateway
resource "azurerm_application_gateway" "example" {
  name                = var.AppgW_name
  location            = var.location
  resource_group_name = azurerm_resource_group.res-g-1.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ipconfig"
    subnet_id = azurerm_subnet.subnet.id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontendPublicIp"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = "backendPool"
  }

  backend_http_settings {
    name                  = "backendHttpSetting"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontendPublicIp"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "backendHttpSetting"
    priority = 10
  }
}