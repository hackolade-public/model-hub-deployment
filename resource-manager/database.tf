/*
 * Copyright © 2016-2025 by IntegrIT S.A. dba Hackolade.  All rights reserved.
 *
 * The copyright to the computer software herein is the property of IntegrIT S.A.
 * The software may be used and/or copied only with the written permission of
 * IntegrIT S.A. or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the software has been supplied.
 */

data "oci_database_autonomous_databases" "existing_db" {
  compartment_id = var.compartment_ocid
  display_name   = var.hub_db_name
}

resource oci_database_autonomous_database hckhub {
  admin_password = var.autonomous_database_password
  autonomous_maintenance_schedule_type = "REGULAR"
  compartment_id = var.compartment_ocid
  compute_count = var.autonomous_database_ecpu_count == 0 ? (length(data.oci_database_autonomous_databases.existing_db.autonomous_databases) > 0 ? 1 : 2) : var.autonomous_database_ecpu_count
  compute_model = "ECPU"
  data_storage_size_in_gb = var.autonomous_database_ecpu_count == 0 ? (length(data.oci_database_autonomous_databases.existing_db.autonomous_databases) > 0 ? "20" : "1024") : var.autonomous_database_storage
  db_name = var.hub_db_name
  db_version = "23ai"
  db_workload = "AJD"
  display_name = var.hub_db_name
  is_auto_scaling_enabled = "false"
  is_auto_scaling_for_storage_enabled = "false"
  is_dedicated = "false"
  is_free_tier = var.autonomous_database_ecpu_count == 0
  is_mtls_connection_required = "false"
  is_preview_version_with_service_terms_accepted = "false"
  license_model = "LICENSE_INCLUDED"
  whitelisted_ips = ["0.0.0.0/0"]
}

locals {
  database_profiles = { for profile in distinct([for p in oci_database_autonomous_database.hckhub.connection_strings[0].profiles : p.consumer_group]) : tostring(profile) => [for p in oci_database_autonomous_database.hckhub.connection_strings[0].profiles : p.value if p.consumer_group == profile][0] }
}

resource "terraform_data" "create_new_schema" {
  triggers_replace = [oci_database_autonomous_database.hckhub.id]

  provisioner "local-exec" {
    on_failure = fail
    environment = {
      ORACLE_PASSWORD = var.autonomous_database_password
      ORACLE_USER = "admin"
      NEW_ORACLE_USER = var.autonomous_database_username
      ORACLE_DB_CONNECTION = local.database_profiles["LOW"]
    }

    command = "podman run --rm -e ORACLE_PASSWORD -e ORACLE_USER -e ORACLE_DB_CONNECTION -e NEW_ORACLE_USER hackoladepublic.azurecr.io/model-hub-sync/seed-first-user:develop"
  }
}

output "OrdsEndpoint" {
  value = format("%s%s", lookup(oci_database_autonomous_database.hckhub.connection_urls[0], "ords_url"), var.autonomous_database_username)
}
