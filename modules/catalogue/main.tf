# Create the Access Package Catalog
resource "azuread_access_package_catalog" "catalog" {
  display_name = var.display_name
  description  = var.description
}

# --- Locals for filtering principals by type ---
locals {
  # Filter for Catalog Owners
  owners_users  = { for p in var.catalog_owners : p.identifier => p if lower(p.type) == "user" }
  owners_groups = { for p in var.catalog_owners : p.identifier => p if lower(p.type) == "group" }

  # Filter for Catalog Creators
  creators_users  = { for p in var.catalog_creators : p.identifier => p if lower(p.type) == "user" }
  creators_groups = { for p in var.catalog_creators : p.identifier => p if lower(p.type) == "group" }

  # Filter for Catalog Readers
  readers_users  = { for p in var.catalog_readers : p.identifier => p if lower(p.type) == "user" }
  readers_groups = { for p in var.catalog_readers : p.identifier => p if lower(p.type) == "group" }

  # Filter for Access Package Managers
  managers_users  = { for p in var.access_package_managers : p.identifier => p if lower(p.type) == "user" }
  managers_groups = { for p in var.access_package_managers : p.identifier => p if lower(p.type) == "group" }
}

# --- Data lookups for principals ---
data "azuread_user" "owner" {
  for_each            = local.owners_users
  user_principal_name = "${each.key}@${var.domain}"
}
data "azuread_group" "owner" {
  for_each     = local.owners_groups
  display_name = each.key
}

data "azuread_user" "creator" {
  for_each            = local.creators_users
  user_principal_name = "${each.key}@${var.domain}"
}
data "azuread_group" "creator" {
  for_each     = local.creators_groups
  display_name = each.key
}

data "azuread_user" "reader" {
  for_each            = local.readers_users
  user_principal_name = "${each.key}@${var.domain}"
}
data "azuread_group" "reader" {
  for_each     = local.readers_groups
  display_name = each.key
}

data "azuread_user" "manager" {
  for_each            = local.managers_users
  user_principal_name = "${each.key}@${var.domain}"
}
data "azuread_group" "manager" {
  for_each     = local.managers_groups
  display_name = each.key
}

# --- Role Assignments ---

# Catalog Owners
resource "azuread_access_package_catalog_role_assignment" "owner_user" {
  for_each = data.azuread_user.owner

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.catalog_owner.object_id
  principal_object_id = each.value.object_id
}
resource "azuread_access_package_catalog_role_assignment" "owner_group" {
  for_each = data.azuread_group.owner

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.catalog_owner.object_id
  principal_object_id = each.value.object_id
}

# Catalog Creators
resource "azuread_access_package_catalog_role_assignment" "creator_user" {
  for_each = data.azuread_user.creator

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.catalog_creator.object_id
  principal_object_id = each.value.object_id
}
resource "azuread_access_package_catalog_role_assignment" "creator_group" {
  for_each = data.azuread_group.creator

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.catalog_creator.object_id
  principal_object_id = each.value.object_id
}

# Catalog Readers
resource "azuread_access_package_catalog_role_assignment" "reader_user" {
  for_each = data.azuread_user.reader

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.catalog_reader.object_id
  principal_object_id = each.value.object_id
}
resource "azuread_access_package_catalog_role_assignment" "reader_group" {
  for_each = data.azuread_group.reader

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.catalog_reader.object_id
  principal_object_id = each.value.object_id
}

# Access Package Managers
resource "azuread_access_package_catalog_role_assignment" "manager_user" {
  for_each = data.azuread_user.manager

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.access_package_manager.object_id
  principal_object_id = each.value.object_id
}
resource "azuread_access_package_catalog_role_assignment" "manager_group" {
  for_each = data.azuread_group.manager

  catalog_id          = azuread_access_package_catalog.catalog.id
  role_id             = data.azuread_access_package_catalog_role.access_package_manager.object_id
  principal_object_id = each.value.object_id
}

# Data lookup for the groups to be added as resources
data "azuread_group" "resource_groups" {
  for_each     = toset(var.group_names)
  display_name = each.key
}

# Associate Groups with the Catalog
resource "azuread_access_package_resource_catalog_association" "group" {
  for_each = data.azuread_group.resource_groups

  catalog_id             = azuread_access_package_catalog.catalog.id
  resource_origin_id     = each.value.object_id
  resource_origin_system = "AadGroup"
}