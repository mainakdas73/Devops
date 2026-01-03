terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.55.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "d008c7cc-9795-4292-bf79-74ae52cda63d"
}