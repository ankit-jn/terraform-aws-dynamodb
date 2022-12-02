resource aws_dynamodb_table "this" {

    name = var.name
    hash_key    = var.partition_key_name
    range_key   = var.sort_key_name

    ## Attribute for Partition Key
    attribute {
        name = var.partition_key_name
        type = var.partition_key_type
    }

    ## Attribute for (Optional) Sort Key
    dynamic "attribute" {
        for_each = (var.sort_key_name == null || var.sort_key_name == "") ? [] : [1]
        
        content {
            name = var.sort_key_name
            type = var.sort_key_type
        }
    }

    billing_mode    = var.billing_mode
    read_capacity   = (var.billing_mode == "PROVISIONED") ? var.read_capacity : null
    write_capacity  = (var.billing_mode == "PROVISIONED") ? var.write_capacity : null

    table_class = var.table_class

    stream_enabled      = var.stream_enabled
    stream_view_type    = var.stream_enabled ? var.stream_view_type : null
    
    dynamic "ttl" {
        for_each = var.enable_ttl ? [1] : [0]
        
        content {
            enabled = true
            attribute_name = var.ttl_attribute
        }
    }

    dynamic "point_in_time_recovery" {
        for_each = var.enable_point_in_time_recovery ? [1] : []
        
        content {
            enabled = true
        }
    }

    server_side_encryption {
        enabled = var.enable_server_side_encryption
        kms_key_arn = var.kms_key
    }

    restore_source_name     = var.restore_source_name
    restore_to_latest_time  = var.restore_to_latest_time

    dynamic "local_secondary_index" {
        for_each = var.local_secondary_indexes

        content {
            name = local_secondary_index.value.name
            range_key = local_secondary_index.value.range_key
            projection_type = try(local_secondary_index.value.projection_type, "ALL")
            non_key_attributes = (try(local_secondary_index.value.projection_type, "ALL") == "INCLUDE"
                                        && try(local_secondary_index.value.non_key_attributes, "") != "") ? (
                                                split(",", local_secondary_index.value.non_key_attributes, "")): null
        }
    }

    dynamic "global_secondary_index" {
        for_each = var.global_secondary_indexes

        content {
            name = global_secondary_index.value.name
            hash_key = global_secondary_index.value.partition_key
            range_key = try(global_secondary_index.value.range_key, null)
            read_capacity   = (var.billing_mode == "PROVISIONED") ? global_secondary_index.value.read_capacity : null
            write_capacity  = (var.billing_mode == "PROVISIONED") ? global_secondary_index.value.write_capacity : null
            projection_type = try(global_secondary_index.value.projection_type, "ALL")
            non_key_attributes = (try(global_secondary_index.value.projection_type, "ALL") == "INCLUDE"
                                        && try(global_secondary_index.value.non_key_attributes, "") != "") ? (
                                                split(",", global_secondary_index.value.non_key_attributes, "")): null
        }
    }

    dynamic "repilca" {
        for_each = var.replicas

        content {
            region_name = replica.value.region_name
            point_in_time_recovery = try(replica.value.point_in_time_recovery, false)
            propagate_tags = try(replica.value.propagate_tags, false)
            kms_key_arn = try(replica.value.kms_key_arn, null)
        }
    }
}   

resource aws_dynamodb_contributor_insights "this" {
    count = var.provision_contributor_insights ? 1 : 0
    
    table_name = var.name

    depends_on = [
        aws_dynamodb_table.this
    ]
}

resource aws_dynamodb_kinesis_streaming_destination "this" {
    count = var.provision_contributor_insights ? 1 : 0

    table_name = var.name
    stream_arn = var.kinesis_stream_arn

    depends_on = [
        aws_dynamodb_table.this
    ]
}