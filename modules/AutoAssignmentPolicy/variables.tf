# modules/access-package-auto-assignment-policy/variables.tf

variable "access_package_id" {
  type        = string
  description = "The ID of the Access Package this policy will be assigned to."
}

variable "display_name" {
  type        = string
  description = "The display name of the assignment policy."
}

variable "description" {
  type        = string
  description = "A description for the assignment policy."
}

variable "membership_rule" {
  type        = string
  description = "The membership rule query. Example: (user.department -eq \"Sales\")."
}

variable "rule_description" {
  type        = string
  description = "A description for the specific membership rule."
}

variable "remove_access_on_leave" {
  type        = bool
  description = "If true, access will be removed when a user no longer matches the membership rule."
  default     = true
}

variable "grace_period_in_days" {
  type        = number
  description = "The number of days to wait before removing access after a user leaves the target scope. Set to 0 for immediate removal."
  default     = 7
}

