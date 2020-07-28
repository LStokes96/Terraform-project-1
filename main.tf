provider "azurerm" {
    features {}
}
resource "azurerm_resource_group" "Netflix" {
    name = "Netflix-RG"
    location = "uk south"
}
module "uk-VirtMSS" {
    source = "./UK/VMSS"
    resource_group_name = azurerm_resource_group.Netflix.name
    resource_group_location = azurerm_resource_group.Netflix.location
    resource_group_tags = "Production"
}
module "uk-MoniT"{
    source = "./UK/Monitor"
    resource_group_name = azurerm_resource_group.Netflix.name
    resource_group_location = azurerm_resource_group.Netflix.location
}
module "France-VirtMSS" {
    source = "./France/VMSS"
    resource_group_name = azurerm_resource_group.Netflix.name
    resource_group_location = "France Central"
    resource_group_tags = "Staging"
}
module "France-MoniT"{
    source = "./UK/Monitor"
    resource_group_name = azurerm_resource_group.Netflix.name
    resource_group_location = "France Central"
}
module "CI-VirtMSS" {
    source = "./Central-India/VMSS"
    resource_group_name = azurerm_resource_group.Netflix.name
    resource_group_location = "East Asia"
    resource_group_tags = "Development"
}
module "uk-MoniT"{
    source = "./UK/Monitor"
    resource_group_name = azurerm_resource_group.Netflix.name
    resource_group_location = "East Asia"
}