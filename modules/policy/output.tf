output "id" {
  description = "The ID of the Azure AD Access Package Assignment Policy."
  value       = azuread_access_package_assignment_policy.policy.id
}

output "display_name" {
  description = "The display name of the policy."
  value       = azuread_access_package_assignment_policy.policy.display_name
}