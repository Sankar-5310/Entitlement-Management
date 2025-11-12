output "id" {
  description = "The ID of the created assignment policy."
  value       = msgraph_resource.auto_assignment_policy.id
}

output "display_name" {
  description = "The display name of the created assignment policy."
  value = msgraph_resource.auto_assignment_policy.body.displayName
}