Terraform Modules for Entitlement Management
This repository contains Terraform modules to manage access packages, catalogs, policies, and auto-assignment rules for organizational resources.

Modules Overview
1. Catalog Module (catalogue)
Defines a catalog for organizing access packages.

Inputs:
display_name: Name of the catalog.
description: Description of the catalog.
group_names: List of group names associated with the catalog.
domain: Domain name for the catalog.
catalog_owners: List of owners (users or groups) of the catalog.
catalog_creators: List of users who can create access packages in the catalog.
access_package_managers: List of users or groups who manage access packages.
Example:
module "Infosec_Team_Catalog" {
  source = "../modules/catalogue"
  display_name = "Infosec Team Catalog"
  description  = "Catalog for IT department resources"
  group_names  = ["TestLicGroup1", "TestLicGroup2", "TestLicGroup3"]
  domain       = "wfscorpdev.com"
  catalog_owners = [{ identifier = "saravichandran", type = "user" }, { identifier = "TestLicGroup1", type = "group" }]
  catalog_creators = [{ identifier = "saravichandran", type = "user" }]
  access_package_managers = [{ identifier = "saravichandran", type = "user" }, { identifier = "TestLicGroup1", type = "group" }]
}
2. Access Package Module (access_package)
Creates access packages within a catalog.

Inputs:
package_name: Name of the access package.
description: Description of the package.
catalog_id: ID of the catalog.
group_names: Groups included in the package.
catalog_resources: Resources from the catalog.
Example:
module "Infosec_Admin_Accesspackage" {
  source = "../modules/access_package"
  package_name = "Infosec Admin"
  description  = "Access package for Infosec Admin"
  catalog_id   = module.Infosec_Team_Catalog.catalog_id
  group_names  = ["TestLicGroup1", "TestLicGroup2", "TestLicGroup3"]
  catalog_resources = module.Infosec_Team_Catalog.catalog_resources
}
3. Auto Assignment Policy Module (AutoAssignmentPolicy)
Automatically assigns access packages based on user attributes.

Inputs:
access_package_id: ID of the access package.
display_name: Name of the policy.
description: Description of the policy.
membership_rule: Rule for user membership.
rule_description: Description of the rule.
grace_period_in_days: Grace period before removal.
Example:
module "sales_auto_assignment_policy" {
  source = "../modules/AutoAssignmentPolicy"
  access_package_id = module.Infosec_Admin_Accesspackage.access_package_id
  display_name = "Automated Assignment Policy"
  description  = "Automatically assign Sales Team Access to all users from the IT department."
  membership_rule = "(user.department -eq "ne")"
  rule_description = "Membership rule for all users from the Sales department."
  grace_period_in_days = 3
}
4. Access Package Policy Module (policy)
Defines approval and review policies for access packages.

Inputs:
access_package_id: ID of the access package.
display_name: Name of the policy.
description: Description of the policy.
domain: Domain name.
duration_in_days: Duration of access.
approval_required: Whether approval is needed.
approval_stages: List of approval stages.
assignment_review_enabled: Enable access reviews.
review_frequency: Frequency of reviews.
review_duration_in_days: Duration of each review.
review_type: Type of review.
reviewers: List of reviewers.
Example:
module "Infosec_Admin_Accesspackage_policy" {
  source = "../modules/policy"
  access_package_id = module.Infosec_Admin_Accesspackage.access_package_id
  display_name = "Default Policy"
  description  = "Default Policy"
  duration_in_days = 30
  domain = "wfscorpdev.com"
  approval_required = true
  approval_stages = [
    { timeout_in_days = 7, justification_required = false, enable_alternative_approver = false,
      primary_approvers = [ { subject_type = "requestorManager" }, { user_principal_name = "saravichandran", subject_type = "singleUser", backup = true } ] },
    { timeout_in_days = 7, justification_required = true, enable_alternative_approver = false,
      primary_approvers = [ { group_display_name = "TestLicgroup2", subject_type = "groupMembers" } ] },
    { timeout_in_days = 7, justification_required = true, enable_alternative_approver = false,
      primary_approvers = [ { user_principal_name = "saravichandran", subject_type = "singleUser" } ] }
  ]
  assignment_review_enabled = true
  review_frequency = "quarterly"
  review_duration_in_days = 14
  review_type = "Reviewers"
  reviewers = [ { group_display_name = "TestLicGroup3", subject_type = "groupMembers" } ]
}
Creating New Modules
To create a new module:

Choose the appropriate module type
(catalog, access package, policy, auto-assignment).

Copy the example block and update the values
Use the provided examples as a template.

Ensure all required fields are provided
Double-check mandatory inputs for each module.

Use consistent naming conventions
Keep names clear and aligned with your organization’s standardsTerraform Modules for Access Management
This repository contains Terraform modules to manage access packages, catalogs, policies, and auto-assignment rules for organizational resources.

Modules Overview
1. Catalog Module (catalogue)
Defines a catalog for organizing access packages.

Inputs:
display_name: Name of the catalog.
description: Description of the catalog.
group_names: List of group names associated with the catalog.
domain: Domain name for the catalog.
catalog_owners: List of owners (users or groups) of the catalog.
catalog_creators: List of users who can create access packages in the catalog.
access_package_managers: List of users or groups who manage access packages.
Example:
module "Infosec_Team_Catalog" {
  source = "../modules/catalogue"
  display_name = "Infosec Team Catalog"
  description  = "Catalog for IT department resources"
  group_names  = ["TestLicGroup1", "TestLicGroup2", "TestLicGroup3"]
  domain       = "wfscorpdev.com"
  catalog_owners = [{ identifier = "saravichandran", type = "user" }, { identifier = "TestLicGroup1", type = "group" }]
  catalog_creators = [{ identifier = "saravichandran", type = "user" }]
  access_package_managers = [{ identifier = "saravichandran", type = "user" }, { identifier = "TestLicGroup1", type = "group" }]
}
2. Access Package Module (access_package)
Creates access packages within a catalog.

Inputs:
package_name: Name of the access package.
description: Description of the package.
catalog_id: ID of the catalog.
group_names: Groups included in the package.
catalog_resources: Resources from the catalog.
Example:
module "Infosec_Admin_Accesspackage" {
  source = "../modules/access_package"
  package_name = "Infosec Admin"
  description  = "Access package for Infosec Admin"
  catalog_id   = module.Infosec_Team_Catalog.catalog_id
  group_names  = ["TestLicGroup1", "TestLicGroup2", "TestLicGroup3"]
  catalog_resources = module.Infosec_Team_Catalog.catalog_resources
}
3. Auto Assignment Policy Module (AutoAssignmentPolicy)
Automatically assigns access packages based on user attributes.

Inputs:
access_package_id: ID of the access package.
display_name: Name of the policy.
description: Description of the policy.
membership_rule: Rule for user membership.
rule_description: Description of the rule.
grace_period_in_days: Grace period before removal.
Example:
module "sales_auto_assignment_policy" {
  source = "../modules/AutoAssignmentPolicy"
  access_package_id = module.Infosec_Admin_Accesspackage.access_package_id
  display_name = "Automated Assignment Policy"
  description  = "Automatically assign Sales Team Access to all users from the IT department."
  membership_rule = "(user.department -eq "ne")"
  rule_description = "Membership rule for all users from the Sales department."
  grace_period_in_days = 3
}
4. Access Package Policy Module (policy)
Defines approval and review policies for access packages.

Inputs:
access_package_id: ID of the access package.
display_name: Name of the policy.
description: Description of the policy.
domain: Domain name.
duration_in_days: Duration of access.
approval_required: Whether approval is needed.
approval_stages: List of approval stages.
assignment_review_enabled: Enable access reviews.
review_frequency: Frequency of reviews.
review_duration_in_days: Duration of each review.
review_type: Type of review.
reviewers: List of reviewers.
Example:
module "Infosec_Admin_Accesspackage_policy" {
  source = "../modules/policy"
  access_package_id = module.Infosec_Admin_Accesspackage.access_package_id
  display_name = "Default Policy"
  description  = "Default Policy"
  duration_in_days = 30
  domain = "wfscorpdev.com"
  approval_required = true
  approval_stages = [
    { timeout_in_days = 7, justification_required = false, enable_alternative_approver = false,
      primary_approvers = [ { subject_type = "requestorManager" }, { user_principal_name = "saravichandran", subject_type = "singleUser", backup = true } ] },
    { timeout_in_days = 7, justification_required = true, enable_alternative_approver = false,
      primary_approvers = [ { group_display_name = "TestLicgroup2", subject_type = "groupMembers" } ] },
    { timeout_in_days = 7, justification_required = true, enable_alternative_approver = false,
      primary_approvers = [ { user_principal_name = "saravichandran", subject_type = "singleUser" } ] }
  ]
  assignment_review_enabled = true
  review_frequency = "quarterly"
  review_duration_in_days = 14
  review_type = "Reviewers"
  reviewers = [ { group_display_name = "TestLicGroup3", subject_type = "groupMembers" } ]
}
Creating New Modules
To create a new module:

Choose the appropriate module type
(catalog, access package, policy, auto-assignment).

Copy the example block and update the values
Use the provided examples as a template.

Ensure all required fields are provided
Double-check mandatory inputs for each module.

Use consistent naming conventions
Keep names clear and aligned with your organization’s standards