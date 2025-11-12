
# Terraform Modules for Entitlement Management

This repository contains Terraform modules to manage access packages, catalogs, policies, and auto-assignment rules for organizational resources.

## Modules Overview

### 1. Catalog Module (`catalogue`)
Defines a catalog for organizing access packages.

#### Inputs:
- `display_name`: Name of the catalog.
- `description`: Description of the catalog.
- `group_names`: List of group names associated with the catalog.
- `domain`: Domain name for the catalog.
- `catalog_owners`: List of owners (users or groups) of the catalog.
- `catalog_creators`: List of users who can create access packages in the catalog.
- `access_package_managers`: List of users or groups who manage access packages.

#### Example:
```hcl
module "Sample_Team_Catalog" {
  source = "../modules/catalogue"
  display_name = "Sample Team Catalog"
  description  = "Catalog for IT department resources"
  group_names  = ["Group1", "Group2", "Group3"]
  domain       = "yourdomain.com"
  catalog_owners = [{ identifier = "userupn", type = "user" }, { identifier = "Group1", type = "group" }]
  catalog_creators = [{ identifier = "userupn", type = "user" }]
  access_package_managers = [{ identifier = "userupn", type = "user" }, { identifier = "Group1", type = "group" }]
}
```

### 2. Access Package Module (`access_package`)
Creates access packages within a catalog.

#### Inputs:
- `package_name`: Name of the access package.
- `description`: Description of the package.
- `catalog_id`: ID of the catalog.
- `group_names`: Groups included in the package.
- `catalog_resources`: Resources from the catalog.

#### Example:
```hcl
module "Sample_Admin_Accesspackage" {
  source = "../modules/access_package"
  package_name = "Sample Admin"
  description  = "Access package for Sample Admin"
  catalog_id   = module.Sample_Team_Catalog.catalog_id
  group_names  = ["Group1", "Group2", "Group3"]
  catalog_resources = module.Sample_Team_Catalog.catalog_resources
}
```

### 3. Auto Assignment Policy Module (`AutoAssignmentPolicy`)
Automatically assigns access packages based on user attributes.

#### Inputs:
- `access_package_id`: ID of the access package.
- `display_name`: Name of the policy.
- `description`: Description of the policy.
- `membership_rule`: Rule for user membership.
- `rule_description`: Description of the rule.
- `grace_period_in_days`: Grace period before removal.

#### Example:
```hcl
module "sales_auto_assignment_policy" {
  source = "../modules/AutoAssignmentPolicy"
  access_package_id = module.Sample_Admin_Accesspackage.access_package_id
  display_name = "Automated Assignment Policy"
  description  = "Automatically assign Sales Team Access to all users from the IT department."
  membership_rule = "(user.department -eq "ne")"
  rule_description = "Membership rule for all users from the Sales department."
  grace_period_in_days = 3
}
```

### 4. Access Package Policy Module (`policy`)
Defines approval and review policies for access packages.

#### Inputs:
- `access_package_id`: ID of the access package.
- `display_name`: Name of the policy.
- `description`: Description of the policy.
- `domain`: Domain name.
- `duration_in_days`: Duration of access.
- `approval_required`: Whether approval is needed.
- `approval_stages`: List of approval stages.
- `assignment_review_enabled`: Enable access reviews.
- `review_frequency`: Frequency of reviews.
- `review_duration_in_days`: Duration of each review.
- `review_type`: Type of review.
- `reviewers`: List of reviewers.

#### Example:
```hcl
module "Sample_Admin_Accesspackage_policy" {
  source = "../modules/policy"
  access_package_id = module.Sample_Admin_Accesspackage.access_package_id
  display_name = "Default Policy"
  description  = "Default Policy"
  duration_in_days = 30
  domain = "yourdomain.com"
  approval_required = true
  approval_stages = [
    { timeout_in_days = 7, justification_required = false, enable_alternative_approver = false,
      primary_approvers = [ { subject_type = "requestorManager" }, { user_principal_name = "userupn", subject_type = "singleUser", backup = true } ] },
    { timeout_in_days = 7, justification_required = true, enable_alternative_approver = false,
      primary_approvers = [ { group_display_name = "group2", subject_type = "groupMembers" } ] },
    { timeout_in_days = 7, justification_required = true, enable_alternative_approver = false,
      primary_approvers = [ { user_principal_name = "userupn", subject_type = "singleUser" } ] }
  ]
  assignment_review_enabled = true
  review_frequency = "quarterly"
  review_duration_in_days = 14
  review_type = "Reviewers"
  reviewers = [ { group_display_name = "Group3", subject_type = "groupMembers" } ]
}
```

## Creating New Modules
To create a new module:
1. Choose the appropriate module type (catalog, access package, policy, auto-assignment).
2. Copy the example block and update the values.
3. Ensure all required fields are provided.
4. Use consistent naming conventions.

