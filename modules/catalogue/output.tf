output "catalog_id" {
  description = "The ID of the created access package catalog."
  value       = azuread_access_package_catalog.catalog.id
}

output "catalog_resources" {
  description = "A map of group resource association IDs, keyed by group display name."
  value = {
    for k, v in azuread_access_package_resource_catalog_association.group :
    k => v.id # The key 'k' is the group name, the value is the association ID.
  }
}