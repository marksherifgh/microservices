provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "microservice-rg"
  location = "UAE North"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "microservice-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "microservice-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B1ms"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "dev"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].value
  sensitive = true
}
