
output "access_package_id" {
  description = "The object ID of the created access package."
  value       = azuread_access_package.this.id
}

output "access_package_name" {
  description = "The display name of the created access package."
  value       = azuread_access_package.this.display_name
}