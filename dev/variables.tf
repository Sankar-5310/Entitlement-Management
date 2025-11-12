
variable "client_id" {
  description = "Azure AD App Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure AD App Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}


