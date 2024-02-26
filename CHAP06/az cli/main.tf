terraform {
  required_version = ">=1.0.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.93.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  cloud {
    organization = "jarvis-ltd"

    workspaces {
      name = "cookbook-ch06"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  prefix = "cookbook"
  location = "ukwest"
}

# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = local.prefix
}

resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg_name.id
  location = local.location
}

# Generate random value for the storage account name
resource "random_string" "storage_account_name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                     = random_string.storage_account_name.result
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "GRS"

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "example" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "index.html"
}

#resource "null_resource" "webapp_static_website" {
#  triggers = {
#    account = azurerm_storage_account.sa.name
#  }
#
#  provisioner "local-exec" {
#    command = "az storage blob service-properties update --account-name ${azurerm_storage_account.sa.name} --static-website true --index-document index.html --404-document 404.html"
#  }
#}
