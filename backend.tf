terraform {
  backend "azurerm" {
    resource_group_name  = "StateRG"
    storage_account_name = "statefileacc1990"  # must be globally unique
    container_name       = "tfstate"
    key                  = "azure-linux-vm.tfstate"

    # Optional: enable state locking & encryption
    use_azuread_auth = true   # Use Azure AD instead of storage key
  }
}
