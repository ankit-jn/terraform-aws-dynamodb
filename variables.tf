variable "name" {
    description = "Unique within a region name of the table."
    type        = string
}

variable "partition_key_name" {
    description = "Name of the Partition (Hash) key."
    type        = string
}

variable "partition_key_type" {
    description = "Type of the Partition (Hash) key."
    type        = string
    default     = "S"

    validation {
        condition = contains(["S", "N", "B"], var.partition_key_type)
        error_message = "Only possible values for `partition_key_type` are `S` (string), `N` (Number) and `B` (Binary)."
    }
}

variable "sort_key_name" {
    description = "Name of the Sort (Range) key."
    type        = string
    default     = null
}

variable "sort_key_type" {
    description = "Type of the Sort (Range) key."
    type        = string
    default     = "S"

    validation {
        condition = contains(["S", "N", "B"], var.sort_key_type)
        error_message = "Only possible values for `sort_key_type` are `S` (string), `N` (Number) and `B` (Binary)."
    }
}

variable "billing_mode" {
    description = "Controls how you are charged for read and write throughput and how you manage capacity."
    type        = string
    default     = "PROVISIONED"

    validation {
        condition = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
        error_message = "Only possible values for `billing_mode` are `PAY_PER_REQUEST` and `PROVISIONED`."
    }
}

variable "read_capacity" {
    description = "Number of read units for this table. If the billing_mode is PROVISIONED, this field is required."
    type        = number
    default     = null
}

variable "write_capacity" {
    description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
    type        = number
    default     = null
}

variable "stream_enabled" {
    description = "Flag to decide if Streams are enabled."
    type        = bool
    default     = false
}

variable "stream_view_type" {
    description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream."
    type        = string
    default     = "NEW_AND_OLD_IMAGES"

    validation {
        condition = contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
        error_message = "Possible values for `stream_view_type` are `KEYS_ONLY`, `NEW_IMAGE`, `OLD_IMAGE`, `NEW_AND_OLD_IMAGES`."
    }
}

variable "enable_point_in_time_recovery" {
    description = "Flag to decide if point-in-time recovery is enabled or disabled for the tables."
    type        = bool
    default     = false
}

variable "restore_source_name" {
    description = "(Optional) Name of the table to restore. Must match the name of an existing table."
    type        = string
    default     = null
}

variable "restore_to_latest_time" {
    description = "(Optional) If set, restores table to the most recent point-in-time recovery point."
    type        = bool
    default     = null
}

variable "table_class" {
    description = "(Optional) Storage class of the table."
    type        = string
    default     = "STANDARD"

    validation {
        condition = contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
        error_message = "Possible values for `stream_view_type` are `STANDARD`, `STANDARD_INFREQUENT_ACCESS`."
    }
}

variable "enable_ttl" {
    description = "(Optional) Flag to decide if ttl is enabled."
    type        = bool
    default     = false
}

variable "ttl_attribute" {
    description = "(Optional) Name of the table attribute to store the TTL timestamp in."
    type        = string
    default     = null
}

variable "enable_server_side_encryption" {
    description = "Flag to decide if enable encryption at rest using an AWS managed KMS customer master key (CMK)."
    type        = bool
    default     = false
}

variable "kms_key" {
    description = "ARN of the CMK to be used for server side encryption if enabled."
    type        = string
    default     = null
}

variable "local_secondary_indexes" {
    description = <<EOF
The list of Local Secondary Index (with the following configuration map for each index) on the table.
name: (Required) Name of the index.
range_key: (Required) Name of the range key.
projection_type: (Optional) Projection type which defines the set of attributes that is copied from a table into a secondary index.
non_key_attribuyes: (Optional) Comma separated non-key attributes name to be used in Index.
EOF
    type = list(map(string))
    default = []
}

variable "global_secondary_indexes" {
    description = <<EOF
The list of Global Secondary Index (with the following configuration map for each index) on the table.
name: (Required) Name of the index
partition_key: (Required) Name of the Partition key. 
range_key: (optional) Name of the range key.
read_capacity: Number of read units for this table. If the billing_mode is PROVISIONED, this field is required.
write_capacity: Number of write units for this table. If the billing_mode is PROVISIONED, this field is required.
projection_type: (Optional) Projection type which defines the set of attributes that is copied from a table into a secondary index.
non_key_attribuyes: (Optional) Comma separated non-key attributes name to be used in Index
EOF
    type = list(map(string))
    default = []
}

variable "repilcas" {
    description = <<EOF
The list of Replica configurations:
region_name: (Required) Region name of the replica.
point_in_time_recovery: (Optional) Flag to decide if Point in time recovery is enabled.
propagate_tags: (Optional) Flag to decide if global table tags will be propagated to replica. 
kms_key_arn: (Optional) ARN of the CMK that should be used for the AWS KMS encryption.
EOF
    type = any
    default = []
}

variable "provision_contributor_insights" {
    description = "Flag to decide if provision a contributor insights resource."
    type        = bool
    default     = false
}

variable "enable_kinesis_streaming_destination" {
    description = "Flag to decide if enable a Kinesis streaming destination for data replication of a DynamoDB table."
    type        = bool
    default     = false
}

variable "kinesis_stream_arn" {
    description = "The ARN for a Kinesis data stream."
    type        = string
    default     = null
}