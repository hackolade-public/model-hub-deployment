/*
 * Copyright © 2016-2025 by IntegrIT S.A. dba Hackolade.  All rights reserved.
 *
 * The copyright to the computer software herein is the property of IntegrIT S.A.
 * The software may be used and/or copied only with the written permission of
 * IntegrIT S.A. or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the software has been supplied.
 */
variable compartment_ocid {}
variable tenancy_ocid {}
variable region {}
variable oci_username {
  description = "Username of an OCI user that is going to be used to push docker images into OCI registry"
}

# Let's remove this variable and generate it
variable hub_db_name {
  default = "hckhub"
  description = "Name of the database that will be created. The name must contain only letters and numbers, starting with a letter. 30 characters max. Spaces are not allowed"
  validation {
    condition     = length(var.hub_db_name) <= 30
    error_message = "The hub_db_name value must be less than 30 characters."
  }
  validation {
    condition     = regex("^[a-zA-Z0-9]+$", var.hub_db_name)
    error_message = "The hub_db_name value must contain only letters and numbers, starting with a letter."
  }
}

variable autonomous_database_username {
  default = "hck_hub"
  description = "value of the database user that will be created"
}
variable autonomous_database_password {
  sensitive = true
  description = "password of the database. This password will be shared with the admin of the database and the one created by autonomous_database_username"
}
variable autonomous_database_ecpu_count {
  default = 0
  type = number
  description = "ECPU count for the database. If 0, then a free tier database will be created. Minimum starts at 2"
}
variable autonomous_database_storage {
  default = 20
  type = number
  description = "Specify the storage you wish to make available to your database. Minimum starts at 20"
}
variable github_token {
  sensitive = true
  nullable = true
  default = ""
  description = "Github token used to download the model files from GitHub"
}
variable github_webhook_secret {
  sensitive = true
  nullable = true
  default = ""
  description = "Secret configured on the Github webhook page"
}
variable gitlab_token {
  sensitive = true
  nullable = true
  default = ""
  description = "Gitlab token used to download the model files from GitLab"
}
variable gitlab_webhook_secret {
  sensitive = true
  nullable = true
  default = ""
  description = "Secret configured on the GitLab webhook page"
}
variable gitlab_server_host_domain_name {
  description = "Domain name for GitLab server"
  nullable = true
  default = ""
}
variable gitlab_server_token {
  sensitive = true
  nullable = true
  default = ""
  description = "Gitlab token used to download the model files from your GitLab server"
}
variable gitlab_server_webhook_secret {
  sensitive = true
  nullable = true
  default = ""
  description = "Secret configured on your GitLab server webhook page"
}
variable hub_domain_name {
  default = "<org>.hackolade.com"
  description = "DNS of the HUB portal"
}
