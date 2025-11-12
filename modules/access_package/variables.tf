variable "package_name" {
  type        = string
  description = "The display name of the access package."
}

variable "description" {
  type        = string
  description = "The description of the access package."
}

variable "catalog_id" {
  type        = string
  description = "The object ID of the catalog this access package belongs to."
}

variable "group_names" {
  type        = list(string)
  description = "A list of group display names that this access package will grant membership to."
  default     = []
}

# --- CORRECTED VARIABLE ---
# This now expects a simple map of { "GroupName" = "association-id" }
variable "catalog_resources" {
  type        = map(string)
  description = "A map of catalog resource association IDs from the catalog module, keyed by display name."
  default     = {}
}

variable "hidden" {
  type        = bool
  description = "Whether the access package is hidden from the requestor."
  default     = false
}