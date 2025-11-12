variable "access_package_id" {
  description = "The ID of the access package this policy applies to."
  type        = string
}

variable "display_name" {
  description = "The display name of the assignment policy."
  type        = string
}

variable "description" {
  description = "The description of the assignment policy."
  type        = string
  default     = "Managed by Terraform"
}

variable "duration_in_days" {
  description = "The duration in days that a user will have access to this access package."
  type        = number
  default     = 0
}

variable "requestor_scope_type" {
  description = "The scope of who can request access. See provider docs for valid values."
  type        = string
  default     = "NoSubjects"
}

# --- Approval Settings ---
variable "approval_required" {
  description = "Whether an approval is required for requests."
  type        = bool
  default     = true
}

variable "approval_stages" {
  description = "A list of approval stages. For approvers, provide an identifier based on the subject_type (e.g., user_principal_name for 'singleUser', group_display_name for 'groupMembers')."
  type = list(object({
    timeout_in_days        = number
    justification_required = bool
    enable_alternative_approver = bool
    primary_approvers = list(object({
      object_id             = optional(string)
      user_principal_name   = optional(string)
      group_display_name    = optional(string)
      subject_type          = string
      backup                = optional(bool)
    }))
    alternative_approvers = optional(list(object({
      object_id             = optional(string)
      user_principal_name   = optional(string)
      group_display_name    = optional(string)
      subject_type          = string
      backup                = optional(bool)
    })))
  }))
  default = []
}

# --- Assignment Review Settings ---
variable "assignment_review_enabled" {
  description = "Whether to enable access reviews for assignments."
  type        = bool
  default     = false
}

variable "review_frequency" {
  description = "The frequency of access reviews. One of `weekly`, `monthly`, `quarterly`, `halfyearly`, `annually`."
  type        = string
  default     = "monthly"
}

variable "review_duration_in_days" {
  description = "The number of days for an access review to be open."
  type        = number
  default     = 7
}

variable "review_type" {
  description = "The type of reviewer. One of `Manager`, `Reviewers`, `Self`."
  type        = string
  default     = "Manager"
}

variable "review_timeout_behavior" {
  description = "The action to take if a reviewer does not respond. One of `keepAccess`, `removeAccess`, `acceptAccessRecommendation`."
  type        = string
  default     = "removeAccess"
}

variable "review_recommendations_enabled" {
  description = "Whether to show AI-based recommendations to reviewers."
  type        = bool
  default     = true
}

variable "review_justification_required" {
  description = "Whether reviewers are required to provide a justification."
  type        = bool
  default     = true
}

variable "reviewers" {
  description = "A list of reviewer objects. Provide an identifier based on the subject_type. Only used if review_type is `Reviewers`."
  type = list(object({
    object_id           = optional(string)
    user_principal_name = optional(string)
    group_display_name  = optional(string)
    subject_type        = string
    backup              = optional(bool)
  }))
  default = []
}

# --- Questions ---
variable "questions" {
  description = "A list of questions to ask the requestor."
  type = list(object({
    required = bool
    text     = string
    sequence = optional(number)
  }))
  default = []
}

variable "domain" {
  type        = string
  description = "User Domain Name"
}