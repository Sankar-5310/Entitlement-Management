locals {
  # 1. Combine all subjects that might need an ID lookup into a single list.
  all_subjects_input = concat(
    flatten([for stage in var.approval_stages : stage.primary_approvers]),
    flatten([for stage in var.approval_stages : try(stage.alternative_approvers, [])]),
    var.reviewers
  )

  # 2. Create distinct lists of identifiers that need to be fetched via data sources.
  #    This logic correctly filters for only the subject types that have these identifiers.
  upns_to_lookup = distinct([
    for s in local.all_subjects_input : s.user_principal_name if try(s.subject_type, "") == "singleUser" && try(s.user_principal_name, null) != null
  ])
  group_names_to_lookup = distinct([
    for s in local.all_subjects_input : s.group_display_name if try(s.subject_type, "") == "groupMembers" && try(s.group_display_name, null) != null
  ])

  # 3. Create lookup maps from the data sources to easily find an object_id.
  user_object_ids_map = {
    for upn, user in data.azuread_user.users : upn => user.object_id
  }
  group_object_ids_map = {
    for name, group in data.azuread_group.groups : name => group.object_id
  }

  # 4. Rebuild the approval_stages list with intelligent object_id resolution.
  approval_stages_processed = [
    for stage in var.approval_stages : {
      timeout_in_days        = stage.timeout_in_days
      justification_required = stage.justification_required
      primary_approvers = [
        for approver in stage.primary_approvers : {
          # THIS IS THE KEY FIX:
          # Use a conditional to decide the object_id.
          # If the subject type is one we look up, run coalesce. Otherwise, the object_id is null.
          object_id = contains(["singleUser", "groupMembers"], approver.subject_type) ? coalesce(
            approver.object_id,
            try(local.user_object_ids_map[approver.user_principal_name], null),
            try(local.group_object_ids_map[approver.group_display_name], null)
            ) : null

          subject_type = approver.subject_type
          backup       = lookup(approver, "backup", null)
        }
      ]
      # You can add similar logic for alternative_approvers if you use them.
    }
  ]

  # 5. Rebuild the reviewers list with the same intelligent logic.
  reviewers_processed = [
    for reviewer in var.reviewers : {
      # Apply the same conditional logic here.
      object_id = contains(["singleUser", "groupMembers"], reviewer.subject_type) ? coalesce(
        reviewer.object_id,
        try(local.user_object_ids_map[reviewer.user_principal_name], null),
        try(local.group_object_ids_map[reviewer.group_display_name], null)
        ) : null

      subject_type = reviewer.subject_type
      backup       = lookup(reviewer, "backup", null)
    }
  ]
}

# --- DATA SOURCES ---

data "azuread_user" "users" {
  for_each            = toset(local.upns_to_lookup)
  user_principal_name = "${each.key}@${var.domain}"
}

data "azuread_group" "groups" {
  for_each     = toset(local.group_names_to_lookup)
  display_name = each.key
}


# --- RESOURCE (No changes needed below this line) ---

resource "azuread_access_package_assignment_policy" "policy" {
  access_package_id = var.access_package_id
  display_name      = var.display_name
  description       = var.description
  duration_in_days  = var.duration_in_days

  requestor_settings {
    scope_type = var.requestor_scope_type
  }

  approval_settings {
    approval_required = var.approval_required

    dynamic "approval_stage" {
      for_each = var.approval_required ? local.approval_stages_processed : []
      content {
        approval_timeout_in_days        = approval_stage.value.timeout_in_days
        approver_justification_required = approval_stage.value.justification_required
        dynamic "primary_approver" {
          for_each = approval_stage.value.primary_approvers
          content {
            object_id    = primary_approver.value.object_id
            subject_type = primary_approver.value.subject_type
            backup       = primary_approver.value.backup
          }
        }
      }
    }
  }

  dynamic "assignment_review_settings" {
    for_each = var.assignment_review_enabled ? [1] : []
    content {
      enabled                         = true
      review_frequency                = var.review_frequency
      duration_in_days                = var.review_duration_in_days
      review_type                     = var.review_type
      access_review_timeout_behavior  = var.review_timeout_behavior
      access_recommendation_enabled   = var.review_recommendations_enabled
      approver_justification_required = var.review_justification_required
      dynamic "reviewer" {
        for_each = local.reviewers_processed
        content {
          object_id    = reviewer.value.object_id
          subject_type = reviewer.value.subject_type
          backup       = reviewer.value.backup
        }
      }
    }
  }

  dynamic "question" {
    for_each = var.questions
    content {
      required = question.value.required
      sequence = lookup(question.value, "sequence", null)
      text {
        default_text = question.value.text
      }
    }
  }
}