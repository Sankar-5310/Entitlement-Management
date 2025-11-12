#Catalog
module "sample_Team_Catalog" {
  source = "../modules/catalogue"

  display_name = "sample Team Catalog"
  description  = "Catalog for IT department resources"
  group_names  = ["TestLicGroup1", "TestLicGroup2", "TestLicGroup3"]
  domain       = "wfscorpdev.com"
  # Assign a user and a group as Catalog Owners
  catalog_owners = [
    {
      identifier = "saravichandran"
      type       = "user"
    },
    {
      identifier = "TestLicGroup1" # The display name of the group
      type       = "group"
    }
  ]

  # Assign a specific user as a Catalog Creator
  catalog_creators = [
    {
      identifier = "saravichandran"
      type       = "user"
    }
  ]

  access_package_managers = [
    {
      identifier = "saravichandran"
      type       = "user"
    },
    {
      identifier = "TestLicGroup1" # The display name of the group
      type       = "group"
    }
  ]
}

#Packages

module "sample_Admin_Accesspackage" {
  source            = "../modules/access_package"
  package_name      = "sample Admin"
  description       = "Access package for sample Admin"
  catalog_id        = module.sample_Team_Catalog.catalog_id
  group_names       = ["TestLicGroup1", "TestLicGroup2", "TestLicGroup3"]
  catalog_resources = module.sample_Team_Catalog.catalog_resources
}

module "sample_Readonly_Accesspackage" {
  source            = "../modules/access_package"
  package_name      = "sample Readonly Admin"
  description       = "Access package for sample Readonly Admin"
  catalog_id        = module.sample_Team_Catalog.catalog_id
  group_names       = ["TestLicGroup1", "TestLicGroup2"]
  catalog_resources = module.sample_Team_Catalog.catalog_resources
}

module "sales_auto_assignment_policy" {
  source = "../../TF6-policy/modules/AutoAssignmentPolicy"

  access_package_id    = module.sample_Admin_Accesspackage.access_package_id
  display_name         = "Automated Assignment Policy"
  description          = "Automatically assign Sales Team Access to all users from the IT department."
  membership_rule      = "(user.department -eq \"ne\")"
  rule_description     = "Membership rule for all users from the Sales department."
  grace_period_in_days = 3
}

module "sample_Readonly_Accesspackage_policy" {
  source = "../modules/policy" # Or your module source

  access_package_id = module.sample_Readonly_Accesspackage.access_package_id
  display_name      = "Default Policy"
  description       = "Default Policy"
  domain            = "wfscorpdev.com"
  approval_required = false
  approval_stages = [
    # STAGE 1: The user's manager must approve first.
    {
      timeout_in_days             = 7
      justification_required      = false
      enable_alternative_approver = false
      primary_approvers = [
        {
          # No identifier needed for manager
          subject_type = "requestorManager"
        },
        # Backup approver is a specific user
        {
          user_principal_name = "saravichandran"
          subject_type        = "singleUser"
          backup              = true
        }
      ]
    },
    # STAGE 2: Any member of the 'IT Approvers' group can approve next.
    {
      timeout_in_days             = 7
      justification_required      = true
      enable_alternative_approver = false
      primary_approvers = [
        {
          # For a group, provide the display name and set subject_type
          group_display_name = "TestLicgroup2"
          subject_type       = "groupMembers"
        }
      ]
    },
    # STAGE 3: A specific user provides the final approval.
    {
      timeout_in_days             = 7
      justification_required      = true
      enable_alternative_approver = false
      primary_approvers = [
        {
          # For a user, provide the UPN and set subject_type
          user_principal_name = "saravichandran"
          subject_type        = "singleUser"
        }
      ]
    }
  ]

  # Enable access reviews performed by a specific group
  assignment_review_enabled = false
  review_frequency          = "quarterly"
  review_duration_in_days   = 14
  # IMPORTANT: To use the 'reviewers' block, review_type must be "Reviewers".
  review_type = "Reviewers"
  reviewers = [
    {
      group_display_name = "TestLicGroup3"
      subject_type       = "groupMembers"
    }
  ]
}

module "sample_Admin_Accesspackage_policy" {
  source = "../modules/policy" # Or your module source

  access_package_id = module.sample_Admin_Accesspackage.access_package_id
  display_name      = "Default Policy"
  description       = "Default Policy"
  duration_in_days  = 30
  domain            = "wfscorpdev.com"
  approval_required = true
  approval_stages = [
    # STAGE 1: The user's manager must approve first.
    {
      timeout_in_days             = 7
      justification_required      = false
      enable_alternative_approver = false
      primary_approvers = [
        {
          # No identifier needed for manager
          subject_type = "requestorManager"
        },
        # Backup approver is a specific user
        {
          user_principal_name = "saravichandran"
          subject_type        = "singleUser"
          backup              = true
        }
      ]
    },
    # STAGE 2: Any member of the 'IT Approvers' group can approve next.
    {
      timeout_in_days             = 7
      justification_required      = true
      enable_alternative_approver = false
      primary_approvers = [
        {
          # For a group, provide the display name and set subject_type
          group_display_name = "TestLicgroup2"
          subject_type       = "groupMembers"
        }
      ]
    },
    # STAGE 3: A specific user provides the final approval.
    {
      timeout_in_days             = 7
      justification_required      = true
      enable_alternative_approver = false
      primary_approvers = [
        {
          # For a user, provide the UPN and set subject_type
          user_principal_name = "saravichandran"
          subject_type        = "singleUser"
        }
      ]
    }
  ]

  # Enable access reviews performed by a specific group
  assignment_review_enabled = true
  review_frequency          = "quarterly"
  review_duration_in_days   = 14
  # IMPORTANT: To use the 'reviewers' block, review_type must be "Reviewers".
  review_type = "Reviewers"
  reviewers = [
    {
      group_display_name = "TestLicGroup3"
      subject_type       = "groupMembers"
    }
  ]
}