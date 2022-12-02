## ARJ-Stack: AWS DynamoDB Terraform module

A Terraform module for provisioning AWS DynamoDB Table resources

### Resources
This module features the following components to be provisioned with different combinations:

- DynamoDB Table [[aws_dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)]
- Contributor Insights [[aws_dynamodb_contributor_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_contributor_insights)]
- Kinesis Streaming Destination [[aws_dynamodb_kinesis_streaming_destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_kinesis_streaming_destination)]

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

### Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-dynamodb) for effectively utilizing this module.

### Inputs
---

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | Unique within a region name of the table. | `string` |  | yes |  |
| <a name="partition_key_name"></a> [partition_key_name](#input\_partition\_key\_name) | Name of the Partition (Hash) key. | `string` |  | yes |  |
| <a name="partition_key_type"></a> [partition_key_type](#input\_partition\_key\_type) | Type of the Partition (Hash) key. | `string` | `"S"` | no |  |
| <a name="sort_key_name"></a> [sort_key_name](#input\_sort\_key\_name) | Name of the Sort (Range) key. | `string` | `null` | no |  |
| <a name="sort_key_type"></a> [sort_key_type](#input\_sort\_key\_type) | Type of the Sort (Range) key. | `string` | `"S"` | no |  |
| <a name="attributes"></a> [attributes](#attribute) | Set of nested attribute definitions. | `list(map(string)` | `[]` | no |  |
| <a name="billing_mode"></a> [billing_mode](#input\_billing\_mode) | Controls how you are charged for read and write throughput and how you manage capacity. | `string` | `"PROVISIONED"` | no |  |
| <a name="read_capacity"></a> [read_capacity](#input\_read\_capacity) | Number of read units for this table. If the billing_mode is PROVISIONED, this field is required. | `number` | `null` | no |  |
| <a name="write_capacity"></a> [write_capacity](#input\_write\_capacity) | Number of write units for this table. If the billing_mode is PROVISIONED, this field is required. | `number` | `null` | no |  |
| <a name="stream_enabled"></a> [stream_enabled](#input\_stream\_enabled) | Flag to decide if Streams are enabled. | `bool` | `false` | no |  |
| <a name="stream_view_type"></a> [stream_view_type](#input\_stream\_view\_type) | When an item in the table is modified, StreamViewType determines what information is written to the table's stream. | `string` | `"NEW_AND_OLD_IMAGES` | no |  |
| <a name="enable_point_in_time_recovery"></a> [enable_point_in_time_recovery](#input\_enable\_point\_in\_time\_recovery) | Flag to decide if point-in-time recovery is enabled or disabled for the tables. | `bool` | `false` | no |  |
| <a name="restore_source_name"></a> [restore_source_name](#input\_restore\_source\_name) | Name of the table to restore. Must match the name of an existing table. | `string` | `null` | no |  |
| <a name="restore_to_latest_time"></a> [restore_to_latest_time](#input\_restore\_to\_latest\_time) | If set, restores table to the most recent point-in-time recovery point. | `bool` | `null` | no |  |
| <a name="table_class"></a> [table_class](#input\_table\_class) | Storage class of the table. | `string` | `"STANDARD"` | no |  |
| <a name="enable_ttl"></a> [enable_ttl](#input\_enable\_ttl) | Flag to decide if ttl is enabled. | `bool` | `false` | no |  |
| <a name="ttl_attribute"></a> [ttl_attribute](#input\_ttl\_attribute) | Name of the table attribute to store the TTL timestamp in. | `string` | `null` | no |  |
| <a name="enable_server_side_encryption"></a> [enable_server_side_encryption](#input\_enable\_server\_side\_encryption) | Flag to decide if enable encryption at rest using an AWS managed KMS customer master key (CMK). | `bool` | `false` | no |  |
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | ARN of the CMK to be used for server side encryption if enabled. | `string` | `null` | no |  |
| <a name="local_secondary_indexes"></a> [local_secondary_indexes](#local\_secondary\_index) | The list of Local Secondary Index (with the following configuration map for each index) on the table. | `list(map(string))` | `[]` | no |  |
| <a name="global_secondary_indexes"></a> [global_secondary_indexes](#global\_secondary\_indexe) | The list of Global Secondary Index (with the following configuration map for each index) on the table. | `list(map(string))` | `[]` | no |  |
| <a name="replicas"></a> [replicas](#replica) | The list of Replica configurations | `any` | `[]` | no |  |
| <a name="provision_contributor_insights"></a> [provision_contributor_insights](#input\_provision\_contributor\_insights) | Flag to decide if provision a contributor insights resource. | `bool` | `false` | no |  |
| <a name="enable_kinesis_streaming_destination"></a> [enable_kinesis_streaming_destination](#input\_enable\_kinesis\_streaming\_destination) | Flag to decide if enable a Kinesis streaming destination for data replication of a DynamoDB table. | `bool` | `false` | no |  |
| <a name="kinesis_stream_arn"></a> [kinesis_stream_arn](#input\_kinesis\_stream\_arn) | The ARN for a Kinesis data stream. | `string` | `null` | no |  |

### Nested Configuration Maps:  

#### attribute

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | Name of the attribute. | `string` |  | yes |
| <a name="type"></a> [type](#input\_type) | Attribute type. Valid values are `S` (string), `N` (number), `B` (binary). | `string` |  | yes |

#### local_secondary_index

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | Name of the index. | `string` |  | yes |
| <a name="range_key"></a> [range_key](#input\_range\_key) | Name of the range key. | `string` |  | yes |
| <a name="projection_type"></a> [projection_type](#input\_projection\_type) | Projection type which defines the set of attributes that is copied from a table into a secondary index. | `string` | `"ALL"` | no |
| <a name="non_key_attribuyes"></a> [non_key_attribuyes](#input\_non\_key\_attribuyes) | Comma separated non-key attributes name to be used in Index. | `string` |  | no |

#### global_secondary_index

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | Name of the index. | `string` |  | yes |
| <a name="partition_key"></a> [partition_key](#input\_partition\_key) | Name of the Partition key. | `string` |  | yes |
| <a name="range_key"></a> [range_key](#input\_range\_key) | Name of the range key. | `string` |  | no |
| <a name="read_capacity"></a> [read_capacity](#input\_read\_capacity) | Number of read units for this table. If the billing_mode is PROVISIONED, this field is required. | `number` |  | no |
| <a name="write_capacity"></a> [write_capacity](#input\_write\_capacity) | Number of write units for this table. If the billing_mode is PROVISIONED, this field is required. | `number` |  | no |
| <a name="projection_type"></a> [projection_type](#input\_projection\_type) | Projection type which defines the set of attributes that is copied from a table into a secondary index. | `string` | `"ALL"` | no |
| <a name="non_key_attribuyes"></a> [non_key_attribuyes](#input\_non\_key\_attribuyes) | Comma separated non-key attributes name to be used in Index. | `string` |  | no |

#### replica

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="region_name"></a> [region_name](#input\_region\_name) | Region name of the replica. | `string` |  | yes |
| <a name="point_in_time_recovery"></a> [point_in_time_recovery](#input\_point\_in\_time\_recovery) | Flag to decide if Point in time recovery is enabled. | `bool` | `false` | no |
| <a name="kms_key_arn"></a> [kms_key_arn](#input\_kms\_key\_arn) | ARN of the CMK that should be used for the AWS KMS encryption. | `string` | `null` | no |

### Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="arn"></a> [arn](#output\_arn) | ARN of the Table. | `string` | 
| <a name="stream_arn"></a> [stream_arn](#output\_stream\_arn) | ARN of the Table Stream. | `string` | 
| <a name="stream_label"></a> [stream_label](#output\_stream\_label) | Timestamp, in ISO 8601 format, for this stream. | `string` | 

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-dynamodb/graphs/contributors).

