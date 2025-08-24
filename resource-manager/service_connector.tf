resource oci_sch_service_connector apply_model_changes_service_connector {
    compartment_id = oci_identity_compartment.modelhub_compartment.id
    display_name = "Apply model changes"
    source {
        kind = "plugin"
        config_map = "{\"queueId\": \"${oci_queue_queue.gitFileChanges.id}\"}"
        plugin_name = "QueueSource"
    }
    target {
        kind = "functions"
        batch_size_in_num = 1
        batch_time_in_sec = 345
        function_id = oci_functions_function.apply-model-changes.id
    }
}
