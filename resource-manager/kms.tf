/*
 * Copyright © 2016-2025 by IntegrIT S.A. dba Hackolade.  All rights reserved.
 *
 * The copyright to the computer software herein is the property of IntegrIT S.A.
 * The software may be used and/or copied only with the written permission of
 * IntegrIT S.A. or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the software has been supplied.
 */
resource oci_kms_vault Stores-secrets-used-by-the-model-hub {
  lifecycle {
    # The destroy fails anyways, so we prevent it to be able to recreate the stack
    prevent_destroy = true
  }

  compartment_id = oci_identity_compartment.modelhub_compartment.id
  display_name = "Stores secrets used by the hub in the current compartment"
  vault_type = "DEFAULT"
}

resource oci_kms_key HubEncryptionKey {
  lifecycle {
    # The destroy fails anyways, so we prevent it to be able to recreate the stack
    prevent_destroy = true
  }

  compartment_id = oci_identity_compartment.modelhub_compartment.id
  desired_state = "ENABLED"
  display_name  = "HubEncryptionKey"
  is_auto_rotation_enabled = "false"
  key_shape {
    algorithm = "AES"
    curve_id  = ""
    length    = "32"
  }
  management_endpoint = oci_kms_vault.Stores-secrets-used-by-the-model-hub.management_endpoint
  protection_mode     = "HSM"
}

resource oci_kms_key_version HubEncryptionKey_key_version {
  lifecycle {
    # The destroy fails anyways, so we prevent it to be able to recreate the stack
    prevent_destroy = true
  }

  key_id              = oci_kms_key.HubEncryptionKey.id
  management_endpoint = oci_kms_vault.Stores-secrets-used-by-the-model-hub.management_endpoint
}

