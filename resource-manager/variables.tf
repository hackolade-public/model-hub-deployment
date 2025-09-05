variable region {}
variable compartment_name {
  description = "Name of the compartment that will be created"
}
variable compartment_ocid {}
variable tenancy_ocid {}
variable autonomous_database_username {
  default = "hck_hub"
  description = "value of the database user that will be created"
}
variable autonomous_database_password {
  sensitive = false
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
variable oci_username {
  description = "Username of an OCI user that is going to be used to push docker images into OCI registry"
}
variable hub_domain_name {
  default = "<org>.hackolade.com"
  description = "DNS of the HUB portal"
}
variable hub_db_name {
  default = "hckhub"
  description = "Name of the database that will be created"
}
variable github_token {
  sensitive = false
  nullable = true
  default = ""
  description = "Github token used to download the model files from GitHub"
}
variable github_webhook_secret {
  sensitive = false
  nullable = true
  default = ""
  description = "Secret configured on the Github webhook page"
}
variable gitlab_token {
  sensitive = false
  nullable = true
  default = ""
  description = "Gitlab token used to download the model files from GitLab"
}
variable gitlab_webhook_secret {
  sensitive = false
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
  sensitive = false
  nullable = true
  default = ""
  description = "Gitlab token used to download the model files from your GitLab server"
}
variable gitlab_server_webhook_secret {
  sensitive = false
  nullable = true
  default = ""
  description = "Secret configured on your GitLab server webhook page"
}
