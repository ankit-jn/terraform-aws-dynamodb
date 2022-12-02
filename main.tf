## Provisioning of DynamoDB Table
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

    dynamic "attribute" {
        for_each = var.attributes

        content {
            name = attribute.value.name
            type = attribute.value.type
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

    dynamic "replica" {
        for_each = var.replicas

        content {
            region_name = replica.value.region_name
            point_in_time_recovery = try(replica.value.point_in_time_recovery, false)
            kms_key_arn = try(replica.value.kms_key_arn, null)
        }
    }
}   

## Contributor Insights for DynamoDB
resource aws_dynamodb_contributor_insights "this" {
    count = var.provision_contributor_insights ? 1 : 0
    
    table_name = var.name

    depends_on = [
        aws_dynamodb_table.this
    ]
}

## Kinesis Streaming Destination
resource aws_dynamodb_kinesis_streaming_destination "this" {
    count = var.enable_kinesis_streaming_destination ? 1 : 0

    table_name = var.name
    stream_arn = var.kinesis_stream_arn

    depends_on = [
        aws_dynamodb_table.this
    ]
}

## Autoscaling for DynamoDB Table
module "table_scaling" {
    source = "./scaling"

    count = ((var.billing_mode == "PROVISIONED") && var.enable_autoscaling) ? 1 : 0

    target_type = "TABLE"
    target_resource_id = "table/${aws_dynamodb_table.this.name}"
    
    autoscale_read_capacity = can(var.read_capacity_autoscaling.max_capacity)
    read_capacity = var.read_capacity
    read_capacity_autoscaling = var.read_capacity_autoscaling

    autoscale_write_capacity = can(var.write_capacity_autoscaling.max_capacity)
    write_capacity = var.write_capacity
    write_capacity_autoscaling = var.write_capacity_autoscaling

    depends_on = [
        aws_dynamodb_table.this
    ]
}

## Autoscaling for Global Secondary Index
module "gsi_scaling" {
    source = "./scaling"

    for_each = ((var.billing_mode == "PROVISIONED") && var.enable_autoscaling
                    && (length(keys(var.gsi_capacity_autoscaling)) > 0)) ? var.gsi_capacity_autoscaling : {}

    target_type = "GSI"
    target_resource_id = "table/${aws_dynamodb_table.this.name}/index/${each.key}"
    
    autoscale_read_capacity = can(each.value.min_read_capacity) && can(each.value.max_read_capacity)
    read_capacity = each.value.min_read_capacity
    read_capacity_autoscaling =  {
                                    max_capacity = each.value.max_read_capacity
                                    scale_in_cooldown  = lookup(each.value, "scale_in_cooldown", 50)
                                    scale_out_cooldown = lookup(each.value, "scale_out_cooldown", 50)
                                    target_value       = lookup(each.value, "target_utilization", 70)
                                    }
    autoscale_write_capacity = can(each.value.min_write_capacity) && can(each.value.max_write_capacity)
    write_capacity = each.value.min_write_capacity
    write_capacity_autoscaling = {
                                    max_capacity = each.value.max_write_capacity
                                    scale_in_cooldown  = lookup(each.value, "scale_in_cooldown", 50)
                                    scale_out_cooldown = lookup(each.value, "scale_out_cooldown", 50)
                                    target_value       = lookup(each.value, "target_utilization", 70)
                                    }

    depends_on = [
        aws_dynamodb_table.this
    ]
}