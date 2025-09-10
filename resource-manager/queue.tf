resource oci_queue_queue gitFileChanges {
  channel_consumption_limit = "100"
  compartment_id            = oci_identity_compartment.modelhub_compartment.id
  dead_letter_queue_delivery_count = "1"
  display_name = "gitFileChanges"
  freeform_tags = {
  }
  retention_in_seconds  = "86400"
  timeout_in_seconds    = "30"
  visibility_in_seconds = "300"
}

