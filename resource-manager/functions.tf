/*
 * Copyright © 2016-2025 by IntegrIT S.A. dba Hackolade.  All rights reserved.
 *
 * The copyright to the computer software herein is the property of IntegrIT S.A.
 * The software may be used and/or copied only with the written permission of
 * IntegrIT S.A. or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the software has been supplied.
 */
locals {
  hub_version = "production"
  image_prefix = format("%s.ocir.io/%s", lower(data.oci_identity_regions.region.regions[0]["key"]), data.oci_objectstorage_namespace.object_storage_namespace.namespace)
  function_image_names = {
    apply-model-changes = format("%s/%s:%s", local.image_prefix,oci_artifacts_container_repository.model-hub-sync-apply-model-changes.display_name,local.hub_version)
    vault-management = format("%s/%s:%s", local.image_prefix,oci_artifacts_container_repository.model-hub-sync-vault-management.display_name,local.hub_version)
    database-migration = format("%s/%s:%s", local.image_prefix,oci_artifacts_container_repository.model-hub-sync-database-migration.display_name,local.hub_version)
    sync = format("%s/%s:%s", local.image_prefix,oci_artifacts_container_repository.model-hub-sync-sync.display_name,local.hub_version)
    sync-all = format("%s/%s:%s", local.image_prefix,oci_artifacts_container_repository.model-hub-sync-sync-all.display_name,local.hub_version)
    git-providers-api = format("%s/%s:%s", local.image_prefix,oci_artifacts_container_repository.model-hub-sync-git-providers-api.display_name,local.hub_version)
    update-oci-functions = format("%s/%s:%s", local.image_prefix,oci_artifacts_container_repository.model-hub-sync-update-oci-functions.display_name,local.hub_version)
  }
}

resource oci_functions_application model-hub-sync {
  depends_on = [terraform_data.copy_docker_images]
  compartment_id = var.compartment_ocid
  config = {
    "HUB_DOMAIN_NAME"      = var.hub_domain_name
    "JWK_URL"              = format("%s/admin/v1/SigningCert/jwk", oci_identity_domain.modelhub_domain.url)
    "OCI_QUEUE_ID"         = oci_queue_queue.gitFileChanges.id
    "OCI_USERNAME"         = format("%s/%s",data.oci_objectstorage_namespace.object_storage_namespace.namespace,var.oci_username)
    "ORACLE_DB_CONNECTION_NO_PARALLELISM" = lookup(local.database_profiles, "LOW") # sqitch fails when running with parallelism
    "ORACLE_DB_CONNECTION" = lookup(local.database_profiles, "HIGH")
    "ORACLE_USER"          = var.hub_db_schema_username
    "QUEUE_ENDPOINT"       = oci_queue_queue.gitFileChanges.messages_endpoint
  }
  display_name = "model-hub-sync"
  freeform_tags = {
  }
  network_security_group_ids = [
  ]
  shape = "GENERIC_X86"
  subnet_ids = [
    oci_core_subnet.private-subnet-model-hub-VCN.id,
  ]
  syslog_url = ""
  trace_config {
    domain_id  = ""
    is_enabled = "false"
  }
}

resource "terraform_data" "copy_docker_images" {
  depends_on = [time_sleep.wait_for_artifacts_to_be_ready]
  triggers_replace = [
    oci_artifacts_container_repository.model-hub-sync-apply-model-changes.id,
    oci_artifacts_container_repository.model-hub-sync-database-migration.id,
    oci_artifacts_container_repository.model-hub-sync-git-providers-api.id,
    oci_artifacts_container_repository.model-hub-sync-sync-all.id,
    oci_artifacts_container_repository.model-hub-sync-sync.id,
    oci_artifacts_container_repository.model-hub-sync-update-oci-functions.id,
    oci_artifacts_container_repository.model-hub-sync-vault-management.id,
    local.function_image_names.apply-model-changes,
    local.function_image_names.vault-management,
    local.function_image_names.database-migration,
    local.function_image_names.sync,
    local.function_image_names.sync-all,
    local.function_image_names.git-providers-api,
    local.function_image_names.update-oci-functions,
  ]

  provisioner "local-exec" {
    on_failure = fail
    environment = {
      OCI_TOKEN = oci_identity_auth_token.auth_token_registry.token
      OCI_USERNAME = format("%s/%s",data.oci_objectstorage_namespace.object_storage_namespace.namespace,var.oci_username)
      COMPARTMENT_NAME = local.repository_name_prefix
      REGION = data.oci_identity_regions.region.regions[0]["key"]
      NAMESPACE = data.oci_objectstorage_namespace.object_storage_namespace.namespace
      HUB_DOMAIN_NAME = var.hub_domain_name
      HUB_VERSION = local.hub_version
    }

    command = "podman run --rm -e OCI_TOKEN -e COMPARTMENT_NAME -e NAMESPACE -e REGION -e OCI_USERNAME -e HUB_DOMAIN_NAME -e HUB_VERSION hackoladepublic.azurecr.io/model-hub-sync/copy-docker-images:${local.hub_version}"
  }
}

resource oci_functions_function apply-model-changes {
  depends_on = [terraform_data.copy_docker_images]
  application_id = oci_functions_application.model-hub-sync.id
  config = {
  }
  display_name = "apply-model-changes"
  freeform_tags = {
  }
  image         = local.function_image_names.apply-model-changes
  memory_in_mbs = "512"
  provisioned_concurrency_config {
    strategy = "NONE"
  }
  timeout_in_seconds = "300"
  trace_config {
    is_enabled = "false"
  }
}

resource oci_functions_function vault-management {
  depends_on = [terraform_data.copy_docker_images]
  application_id = oci_functions_application.model-hub-sync.id
  config = {
  }
  display_name = "vault-management"
  freeform_tags = {
  }
  image         = local.function_image_names.vault-management
  memory_in_mbs = "256"
  provisioned_concurrency_config {
    strategy = "NONE"
  }
  timeout_in_seconds = "300"
  trace_config {
    is_enabled = "false"
  }
}

resource oci_functions_function database-migration {
  depends_on = [terraform_data.copy_docker_images]
  application_id = oci_functions_application.model-hub-sync.id
  config = {
  }
  display_name = "database-migration"
  freeform_tags = {
  }
  image         = local.function_image_names.database-migration
  memory_in_mbs = "128"
  provisioned_concurrency_config {
    strategy = "NONE"
  }
  timeout_in_seconds = "300"
  trace_config {
    is_enabled = "false"
  }
}

resource oci_functions_function sync {
  depends_on = [terraform_data.copy_docker_images]
  application_id = oci_functions_application.model-hub-sync.id
  config = {
  }
  display_name = "sync"
  freeform_tags = {
  }
  image         = local.function_image_names.sync
  memory_in_mbs = "128"
  provisioned_concurrency_config {
    strategy = "NONE"
  }
  timeout_in_seconds = "300"
  trace_config {
    is_enabled = "false"
  }
}

resource oci_functions_function sync-all {
  depends_on = [terraform_data.copy_docker_images]
  application_id = oci_functions_application.model-hub-sync.id
  config = {
  }
  display_name = "sync-all"
  freeform_tags = {
  }
  image         = local.function_image_names.sync-all
  memory_in_mbs = "128"
  provisioned_concurrency_config {
    strategy = "NONE"
  }
  timeout_in_seconds = "300"
  trace_config {
    is_enabled = "false"
  }
}

resource oci_functions_function git-providers-api {
  depends_on = [terraform_data.copy_docker_images]
  application_id = oci_functions_application.model-hub-sync.id
  config = {
  }
  display_name = "git-providers-api"
  freeform_tags = {
  }
  image         = local.function_image_names.git-providers-api
  memory_in_mbs = "128"
  provisioned_concurrency_config {
    strategy = "NONE"
  }
  timeout_in_seconds = "60"
  trace_config {
    is_enabled = "false"
  }
}

resource oci_functions_function update-oci-functions {
  depends_on = [terraform_data.copy_docker_images]
  application_id = oci_functions_application.model-hub-sync.id
  config = {
  }
  display_name = "update-oci-functions"
  freeform_tags = {
  }
  image         = local.function_image_names.update-oci-functions
  memory_in_mbs = "128"
  provisioned_concurrency_config {
    strategy = "NONE"
  }
  timeout_in_seconds = "300"
  trace_config {
    is_enabled = "false"
  }
}
