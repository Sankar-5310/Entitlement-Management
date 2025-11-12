resource "azuread_access_package" "this" {
  catalog_id   = var.catalog_id
  display_name = var.package_name
  description  = var.description
  hidden       = var.hidden
}

# --- CORRECTED RESOURCE ASSOCIATION ---
# This uses the correct resource and a for_each loop that works.
resource "azuread_access_package_resource_package_association" "this" {
  # We iterate over the list of group names, which is known at plan time.
  for_each = toset(var.group_names)

  access_package_id = azuread_access_package.this.id

  # We look up the association ID from the map using the current group name (each.key).
  # The value is unknown at plan, but the key is known, which satisfies Terraform's requirement.
  catalog_resource_association_id = var.catalog_resources[each.key]

  # For groups being added to a package, the access type is "Member".
  access_type = "Member"
}