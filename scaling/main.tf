resource aws_appautoscaling_target "read" {
    count = var.autoscale_read_capacity ? 1 : 0

    max_capacity       = var.read_capacity_autoscaling.max_capacity
    min_capacity       = var.read_capacity
    resource_id        = var.target_resource_id
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    service_namespace  = "dynamodb"
}

resource aws_appautoscaling_policy "read_policy" {
    count = var.autoscale_read_capacity ? 1 : 0

    name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read[0].resource_id}"
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.read[0].resource_id
    scalable_dimension = aws_appautoscaling_target.read[0].scalable_dimension
    service_namespace  = aws_appautoscaling_target.read[0].service_namespace

    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type = "DynamoDBReadCapacityUtilization"
        }

        scale_in_cooldown  = lookup(var.read_capacity_autoscaling, "scale_in_cooldown", 50)
        scale_out_cooldown = lookup(var.read_capacity_autoscaling, "scale_out_cooldown", 50)
        target_value       = lookup(var.read_capacity_autoscaling, "target_utilization", 70)
    }
}

resource aws_appautoscaling_target "write" {
    count = var.autoscale_write_capacity ? 1 : 0

    max_capacity       = var.write_capacity_autoscaling.max_capacity
    min_capacity       = var.write_capacity
    resource_id        = var.target_resource_id
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    service_namespace  = "dynamodb"
}

resource aws_appautoscaling_policy "write_policy" {
    count = var.autoscale_write_capacity ? 1 : 0

    name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write[0].resource_id}"
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.write[0].resource_id
    scalable_dimension = aws_appautoscaling_target.write[0].scalable_dimension
    service_namespace  = aws_appautoscaling_target.write[0].service_namespace

    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type = "DynamoDBWriteCapacityUtilization"
        }

        scale_in_cooldown  = lookup(var.write_capacity_autoscaling, "scale_in_cooldown", 50)
        scale_out_cooldown = lookup(var.write_capacity_autoscaling, "scale_out_cooldown", 50)
        target_value       = lookup(var.write_capacity_autoscaling, "target_utilization", 70)
    }
}
