/*
 * Copyright © 2016-2025 by IntegrIT S.A. dba Hackolade.  All rights reserved.
 *
 * The copyright to the computer software herein is the property of IntegrIT S.A.
 * The software may be used and/or copied only with the written permission of
 * IntegrIT S.A. or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the software has been supplied.
 */

# Wait for the functions and policies to be ready
# OCI policies can take several minutes to fully propagate, especially for vault access
resource "time_sleep" "wait_for_functions_to_be_ready" {
  triggers = {
    database_migration = oci_functions_function.database-migration.id
    hck_hub_functions_policy =oci_identity_policy.hck-hub-functions.id
    hck_hub_functions_vault_and_secrets_policy =oci_identity_policy.hck-hub-functions-secrets.id
    hck_hub_functions_dynamic_group = oci_identity_dynamic_group.hck-hub-functions.id
    kms_vault = oci_kms_vault.Stores-secrets-used-by-the-model-hub.id
  }
  create_duration = "3m"
}

# Force policy propagation by updating the existing policy. Without a manual change, the function gets stuck in a permission denied
# until a manual change is made to force OCI to refresh the policy
resource "null_resource" "refresh_vault_policy" {
  depends_on = [
    oci_identity_policy.hck-hub-functions-secrets,
    time_sleep.wait_for_functions_to_be_ready
  ]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Refreshing vault policy to force propagation..."

      # Update the policy description to force refresh
      oci iam policy update \
        --policy-id "${oci_identity_policy.hck-hub-functions-secrets.id}" \
        --statements "[\"allow dynamic-group ${var.compartment_name}-hck-hub-functions to read secret-family in compartment id ${oci_identity_compartment.modelhub_compartment.id}\"]"

      echo "Policy refreshed, waiting for propagation..."
      sleep 30
    EOT
  }

  triggers = {
    original_policy = oci_identity_policy.hck-hub-functions-secrets.id
    timestamp = timestamp()
  }
}

# Wait for the refreshed policy to propagate
resource "time_sleep" "wait_for_refreshed_policy" {
  depends_on = [null_resource.refresh_vault_policy]
  create_duration = "1m"
}

resource "oci_functions_invoke_function" "database-migration" {
  depends_on = [
    terraform_data.create_new_schema,
    time_sleep.wait_for_functions_to_be_ready,
    time_sleep.wait_for_refreshed_policy
  ]
  function_id = oci_functions_function.database-migration.id

  fn_intent = "httprequest"
  fn_invoke_type = "sync"
  base64_encode_content = false
}
