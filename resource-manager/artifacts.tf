resource oci_artifacts_container_configuration container_configuration {
  compartment_id                      = oci_identity_compartment.modelhub_compartment.id
  is_repository_created_on_first_push = "false"
}

resource oci_artifacts_container_repository model-hub-sync-apply-model-changes {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  display_name = "${var.compartment_name}/apply-model-changes"
  freeform_tags = {}
  is_immutable = "false"
  is_public    = "false"
}

resource oci_artifacts_container_repository model-hub-sync-database-migration {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  display_name = "${var.compartment_name}/database-migration"
  freeform_tags = {}
  is_immutable = "false"
  is_public    = "false"
}

resource oci_artifacts_container_repository model-hub-sync-sync {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  display_name = "${var.compartment_name}/sync"
  freeform_tags = {}
  is_immutable = "false"
  is_public    = "false"
}

resource oci_artifacts_container_repository model-hub-sync-update-oci-functions {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  display_name = "${var.compartment_name}/update-oci-functions"
  freeform_tags = {}
  is_immutable = "false"
  is_public    = "false"
}

resource "terraform_data" "copy_docker_images" {
  triggers_replace = [
    oci_artifacts_container_repository.model-hub-sync-apply-model-changes.id,
    oci_artifacts_container_repository.model-hub-sync-database-migration.id,
    oci_artifacts_container_repository.model-hub-sync-sync.id,
    oci_artifacts_container_repository.model-hub-sync-update-oci-functions.id,
]

  provisioner "local-exec" {
    on_failure = fail
    environment = {
      OCI_TOKEN = oci_identity_auth_token.auth_token_registry.token
      OCI_USERNAME = format("%s/%s",data.oci_objectstorage_namespace.object_storage_namespace.namespace,var.oci_username)
      COMPARTMENT_NAME = var.compartment_name
      REGION = data.oci_identity_regions.region.regions[0]["key"]
      NAMESPACE = data.oci_objectstorage_namespace.object_storage_namespace.namespace
    }

    command = <<EOT
      podman run --rm -e OCI_TOKEN -e COMPARTMENT_NAME -e NAMESPACE -e REGION -e OCI_USERNAME hackoladepublic.azurecr.io/model-hub-sync/copy-docker-images:develop
    EOT
  }
}
