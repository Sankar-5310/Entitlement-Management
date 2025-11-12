data "azuread_access_package_catalog_role" "catalog_owner" {
  display_name = "Catalog owner"
}

data "azuread_access_package_catalog_role" "catalog_reader" {
  display_name = "Catalog reader"
}

data "azuread_access_package_catalog_role" "catalog_creator" {
  display_name = "Catalog creator"
}

data "azuread_access_package_catalog_role" "access_package_manager" {
  display_name = "AccessPackages manager"
}