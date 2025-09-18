/*
 * Copyright © 2016-2025 by IntegrIT S.A. dba Hackolade.  All rights reserved.
 *
 * The copyright to the computer software herein is the property of IntegrIT S.A.
 * The software may be used and/or copied only with the written permission of
 * IntegrIT S.A. or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the software has been supplied.
 */
data "oci_identity_users" "all_users" {
  compartment_id = var.tenancy_ocid

  filter {
    name   = "name"
    values = [var.oci_username]
  }

  count = 1
}

resource oci_identity_auth_token auth_token_registry {
  description = "${var.compartment_name}-token-oci-registry"
  user_id     = data.oci_identity_users.all_users[0].users[0].id
}

resource oci_identity_compartment modelhub_compartment {
  compartment_id = var.compartment_ocid
  description = "For managing all model hub portal componenents"
  freeform_tags = {}
  name = var.compartment_name
}

resource oci_identity_dynamic_group hck-hub-functions {
  compartment_id = var.tenancy_ocid
  description = "Dynamic group to give functions access to other OCI components"
  freeform_tags = {}
  matching_rule = "Any {All {resource.type = 'fnfunc',  resource.compartment.id = '${oci_identity_compartment.modelhub_compartment.id}'},All {resource.type = 'serviceconnector',  resource.compartment.id = '${oci_identity_compartment.modelhub_compartment.id}'}, ALL {resource.type='resourceschedule', resource.id='${oci_resource_scheduler_schedule.update-oci-functions.id}'}}"
  name          = "${var.compartment_name}-hck-hub-functions"
}

resource oci_identity_policy hck-hub-functions {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  description = "Give functions access to other components"
  name = "${var.compartment_name}-hck-hub-functions"
  statements = [
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to use queues in compartment ${var.compartment_name}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to {QUEUE_READ, QUEUE_CONSUME} in compartment id ${oci_identity_compartment.modelhub_compartment.id} where all {request.principal.type='serviceconnector', target.queue.id='${oci_queue_queue.gitFileChanges.id}', request.principal.compartment.id='${oci_identity_compartment.modelhub_compartment.id}'}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to use fn-function in compartment id ${oci_identity_compartment.modelhub_compartment.id} where all {request.principal.type='serviceconnector', request.principal.compartment.id='${oci_identity_compartment.modelhub_compartment.id}'}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to use fn-invocation in compartment id ${oci_identity_compartment.modelhub_compartment.id} where all {request.principal.type= 'serviceconnector', request.principal.compartment.id='${oci_identity_compartment.modelhub_compartment.id}'}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to manage functions-family in compartment id ${oci_identity_compartment.modelhub_compartment.id}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to manage repos in compartment id ${oci_identity_compartment.modelhub_compartment.id}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to read objectstorage-namespaces in compartment id ${oci_identity_compartment.modelhub_compartment.id}",
    "allow any-user to use functions-family in compartment ${var.compartment_name} where ALL {request.principal.type= 'ApiGateway', request.resource.compartment.id = '${oci_identity_compartment.modelhub_compartment.id}'}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to read vaults in compartment id ${oci_identity_compartment.modelhub_compartment.id}",
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to inspect compartments in compartment id ${oci_identity_compartment.modelhub_compartment.id}"
  ]
}

resource oci_identity_policy hck-hub-functions-secrets {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  description = "Give functions access to the vault and secrets"
  name = "${var.compartment_name}-hck-hub-functions-secrets"
  statements = [
    "allow dynamic-group ${var.compartment_name}-hck-hub-functions to read secret-family in compartment id ${oci_identity_compartment.modelhub_compartment.id}"
  ]
}
