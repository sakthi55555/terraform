# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

resource "null_resource" "install_azure_cli" {
  provisioner "local-exec" {
    command = <<EOH

      echo "Installing AzureCLI"
      apt-get update
            # install requirements
      apt-get install -y curl apt-transport-https lsb-release gnupg jq
            # add Microsoft as a trusted source
      curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
      AZ_REPO=$(lsb_release -cs)
      echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
      apt-get update
      apt-get install azure-cli

      EOH

    interpreter = ["/bin/bash", "-c"]
}
}
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "westus2"
}
