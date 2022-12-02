output "arn" {
    description = "ARN of the Table."
    value       = aws_dynamodb_table.this.arn
}

output "stream_arn" {
    description = "ARN of the Table Stream."
    value       = var.stream_enabled ? aws_dynamodb_table.this.stream_arn : ""
}

output "stream_label" {
    description = "Timestamp, in ISO 8601 format, for this stream."
    value       = var.stream_enabled ? aws_dynamodb_table.this.stream_label : ""
}