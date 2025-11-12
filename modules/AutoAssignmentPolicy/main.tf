terraform {
  required_version = ">=1.4.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
    msgraph = {
      source  = "microsoft/msgraph"
      version = ">=0.2.0"
    }
  }
}

resource "msgraph_resource" "auto_assignment_policy" {
  url         = "/identityGovernance/entitlementManagement/assignmentPolicies"
  api_version = "v1.0"

  body = {
    "displayName"            = var.display_name
    "description"            = var.description
    "allowedTargetScope"     = "specificDirectoryUsers"
    "specificAllowedTargets" = [
      {
        "@odata.type"  = "#microsoft.graph.attributeRuleMembers"
        "description"    = var.rule_description
        "membershipRule" = var.membership_rule
      }
    ]
    "automaticRequestSettings" = {
      "requestAccessForAllowedTargets"           = true
      "removeAccessWhenTargetLeavesAllowedTargets" = var.remove_access_on_leave
      "gracePeriodBeforeAccessRemoval"           = var.grace_period_in_days > 0 ? "P${var.grace_period_in_days}D" : "PT0S"
    }
    "accessPackage" = {
      "id" = var.access_package_id
    }
    
  }
  
}