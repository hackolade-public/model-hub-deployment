resource oci_resource_scheduler_schedule update-oci-functions {
  action         = "START_RESOURCE"
  compartment_id = var.compartment_ocid
  defined_tags = {}
  description  = "Updates docker images for OCI functions and run db migrations"
  display_name = "${var.compartment_name}-update-oci-functions"
  freeform_tags = {
  }
  recurrence_details = "FREQ=HOURLY;INTERVAL=1"
  recurrence_type    = "ICAL"
  resources {
    id = oci_functions_function.update-oci-functions.id
    metadata = {}
  }
  resources {
    id = oci_functions_function.database-migration.id
    metadata = {}
  }
  state = "ACTIVE"
  time_starts = timeadd(timestamp(), "10m")
}
