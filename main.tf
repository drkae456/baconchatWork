# Provider configuration
provider "azurerm" {
  features {}
}

# Data source for the existing Resource Group
data "azurerm_resource_group" "baconchat" {
  name = "baconchat"
}

# Data source for the existing Azure Container Registry
data "azurerm_container_registry" "acr" {
  name                = "baconchatwork"
  resource_group_name = data.azurerm_resource_group.baconchat.name
}

# Azure Container Group resource
resource "azurerm_container_group" "aci" {
  name                = "baconchat-webapp"
  resource_group_name = data.azurerm_resource_group.baconchat.name
  location            = data.azurerm_resource_group.baconchat.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "baconchat-webapp"  # Must be globally unique

  container {
    name   = "webapp"
    image  = "${data.azurerm_container_registry.acr.login_server}/baconchatportfolio:latest"
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      NODE_ENV = "development"
    }

    commands = ["npm", "run", "dev"]
  }

  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  tags = {
    environment = "development"
  }
}

# Outputs
output "aci_fqdn" {
  value = azurerm_container_group.aci.fqdn
}

output "aci_ip_address" {
  value = azurerm_container_group.aci.ip_address
}
