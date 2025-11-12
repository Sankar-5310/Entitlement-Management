# modules/azuread-catalog/variables.tf

variable "display_name" {
  type        = string
  description = "The display name for the access package catalog."
}

variable "description" {
  type        = string
  description = "The description of the access package catalog."
}

variable "domain" {
  type        = string
  description = "The domain name to append to user identifiers to form the full User Principal Name (UPN). Example: 'example.com'."
}

variable "catalog_owners" {
  type = list(object({
    identifier = string
    type       = string
  }))
  description = "A list of principals to be assigned the 'Catalog owner' role. 'identifier' is the UPN for a user or Display Name for a group. 'type' must be 'user' or 'group'."
  default     = []

  validation {
    condition = alltrue([
      for principal in var.catalog_owners : contains(["user", "group"], lower(principal.type))
    ])
    error_message = "All principals in 'catalog_owners' must have a 'type' of either 'user' or 'group'."
  }
}

variable "catalog_creators" {
  type = list(object({
    identifier = string
    type       = string
  }))
  description = "A list of principals to be assigned the 'Catalog creator' role."
  default     = []

  validation {
    condition = alltrue([
      for principal in var.catalog_creators : contains(["user", "group"], lower(principal.type))
    ])
    error_message = "All principals in 'catalog_creators' must have a 'type' of either 'user' or 'group'."
  }
}

variable "catalog_readers" {
  type = list(object({
    identifier = string
    type       = string
  }))
  description = "A list of principals to be assigned the 'Catalog reader' role."
  default     = []

  validation {
    condition = alltrue([
      for principal in var.catalog_readers : contains(["user", "group"], lower(principal.type))
    ])
    error_message = "All principals in 'catalog_readers' must have a 'type' of either 'user' or 'group'."
  }
}

variable "access_package_managers" {
  type = list(object({
    identifier = string
    type       = string
  }))
  description = "A list of principals to be assigned the 'Access package manager' role."
  default     = []

  validation {
    condition = alltrue([
      for principal in var.access_package_managers : contains(["user", "group"], lower(principal.type))
    ])
    error_message = "All principals in 'access_package_managers' must have a 'type' of either 'user' or 'group'."
  }
}

variable "group_names" {
  type        = list(string)
  description = "A list of display names for Azure AD groups to add as resources to this catalog."
  default     = []
}