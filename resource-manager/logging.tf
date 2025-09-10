resource oci_logging_log_group hckhub_logs {
  compartment_id = oci_identity_compartment.modelhub_compartment.id
  display_name = "hckhub_logs"
  freeform_tags = {}
}

resource oci_logging_log model_hub_service_connector_logs {
  configuration {
    compartment_id = oci_identity_compartment.modelhub_compartment.id
    source {
      category = "runlog"
      parameters = {
      }
      resource    = oci_sch_service_connector.apply_model_changes_service_connector.id
      service     = "och"
      source_type = "OCISERVICE"
    }
  }
  display_name = "model_hub_service_connector_logs"
  freeform_tags = {
  }
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.hckhub_logs.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

resource oci_logging_log model_hub_functions_logs {
  configuration {
    compartment_id = oci_identity_compartment.modelhub_compartment.id
    source {
      category = "invoke"
      parameters = {}
      resource    = oci_functions_application.model-hub-sync.id
      service     = "functions"
      source_type = "OCISERVICE"
    }
  }
  display_name = "model_hub_functions_logs"
  freeform_tags = {}
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.hckhub_logs.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

resource oci_logging_log model_hub_api_execution {
  configuration {
    compartment_id = oci_identity_compartment.modelhub_compartment.id
    source {
      category = "execution"
      parameters = {
      }
      resource    = oci_apigateway_deployment.model-hub-api.id
      service     = "apigateway"
      source_type = "OCISERVICE"
    }
  }
  defined_tags = {}
  display_name = "model_hub_api_execution"
  freeform_tags = {
  }
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.hckhub_logs.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

resource oci_logging_log model_hub_api_access {
  configuration {
    compartment_id = oci_identity_compartment.modelhub_compartment.id
    source {
      category = "access"
      parameters = {
      }
      resource    = oci_apigateway_deployment.model-hub-api.id
      service     = "apigateway"
      source_type = "OCISERVICE"
    }
  }
  defined_tags = {}
  display_name = "model_hub_api_access"
  freeform_tags = {
  }
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.hckhub_logs.id
  log_type           = "SERVICE"
  retention_duration = "30"
}
