data oci_objectstorage_namespace object_storage_namespace {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
}

resource "time_sleep" "wait_for_namespace" {
  depends_on = [data.oci_objectstorage_namespace.object_storage_namespace]

  create_duration = "5s"
}
