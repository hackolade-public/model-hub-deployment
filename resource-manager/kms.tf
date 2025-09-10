resource oci_kms_vault Stores-secrets-used-by-the-model-hub {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  display_name = "Stores secrets used by the hub in the current compartment"
  vault_type = "DEFAULT"
}

resource oci_kms_key HubEncryptionKey {
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
  key_id              = oci_kms_key.HubEncryptionKey.id
  management_endpoint = oci_kms_vault.Stores-secrets-used-by-the-model-hub.management_endpoint
}

