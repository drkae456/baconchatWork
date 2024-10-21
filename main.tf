provider "azurerm" {
  features {}
  subscription_id =  var.subscription_id
}

# If the Resource Group and ACR already exist, use data sources
data "azurerm_resource_group" "baconchat" {
  name = "baconChat" # Replace with the actual name of your resource group
}

data "azurerm_container_registry" "acr" {
  name                = "baconchatwork" # Replace with the actual name of your ACR
  resource_group_name = data.azurerm_resource_group.baconchat.name
}

# Azure Container Instance (ACI)
resource "azurerm_container_group" "aci" {
  name                = "baconchat-container-instance"
  resource_group_name = data.azurerm_resource_group.baconchat.name
  location            = data.azurerm_resource_group.baconchat.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "baconchat-instance" # Must be globally unique

  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "baconchat"
    image  = "${data.azurerm_container_registry.acr.login_server}/baconchatportfolio:latest"
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      NODE_ENV = "development"
    }

    commands = ["npm", "run", "dev"]
  }

  tags = {
    environment = "development"
  }
}

# Outputs
output "aci_ip_address" {
  value = azurerm_container_group.aci.ip_address
}
