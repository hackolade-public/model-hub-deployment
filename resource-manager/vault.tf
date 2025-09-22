/*
 * Copyright © 2016-2025 by IntegrIT S.A. dba Hackolade.  All rights reserved.
 *
 * The copyright to the computer software herein is the property of IntegrIT S.A.
 * The software may be used and/or copied only with the written permission of
 * IntegrIT S.A. or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the software has been supplied.
 */
resource oci_vault_secret oracle_password_secret {
  compartment_id = var.compartment_ocid
  description = "Password to connect to the Hub database"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.autonomous_database_password)
  }
  secret_name = "ORACLE_PASSWORD"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

resource oci_vault_secret oci_token {
  compartment_id = var.compartment_ocid
  description = "Token used to push images into OCI container registry"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(oci_identity_auth_token.auth_token_registry.token)
  }
  secret_name = "OCI_TOKEN"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

resource oci_vault_secret github_webhook_secret {
  compartment_id = var.compartment_ocid
  description = "Webhook secret configured on GitHub"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.github_webhook_secret == "" ? "CHANGE_ME" : var.github_webhook_secret)
  }
  secret_name = "GITHUB_WEBHOOK_SECRET"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

resource oci_vault_secret github_token {
  compartment_id = var.compartment_ocid
  description = "Token used to access content of GitHub repositories"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.github_token == "" ? "CHANGE_ME" : var.github_token)
  }
  secret_name = "GITHUB_TOKEN"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

resource oci_vault_secret gitlab_webhook_secret {
  compartment_id = var.compartment_ocid
  description = "Webhook secret configured on GitLab"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.gitlab_webhook_secret == "" ? "CHANGE_ME" : var.gitlab_webhook_secret)
  }
  secret_name = "GITLAB_WEBHOOK_SECRET"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

resource oci_vault_secret gitlab_token {
  compartment_id = var.compartment_ocid
  description = "Token used to access content of GitLab repositories"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.gitlab_token == "" ? "CHANGE_ME" : var.gitlab_token)
  }
  secret_name = "GITLAB_TOKEN"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

resource oci_vault_secret gitlab_server_webhook_secret {
  compartment_id = var.compartment_ocid
  description = "Webhook secret configured on GitLab server"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.gitlab_server_webhook_secret == "" ? "CHANGE_ME" : var.gitlab_server_webhook_secret)
  }
  secret_name = "GITLAB_SERVER_WEBHOOK_SECRET"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

resource oci_vault_secret gitlab_server_token {
  compartment_id = var.compartment_ocid
  description = "Token used to access content of GitLab server repositories"
  freeform_tags = {
  }
  key_id = oci_kms_key.HubEncryptionKey.id
  metadata = {
  }
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.gitlab_server_token == "" ? "CHANGE_ME" : var.gitlab_server_token)
  }
  secret_name = "GITLAB_SERVER_TOKEN"
  vault_id    = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
}

