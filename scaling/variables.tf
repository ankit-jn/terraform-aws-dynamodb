variable "target_resource_id"{
    description = "The Resource ID of the Autoscaling Target"
    type        = string
}

variable "autoscale_read_capacity" {
    description = "Flag to decide if Read Capacity autoscaling should be configured."
    type        = bool
}

variable "read_capacity" {
    description = "Number of minimum read units for this table."
    type        = number
}

variable "read_capacity_autoscaling" {
    description = <<EOF
The Configuration for Read capacity autoscaling:
max_capacity: (Required) Number of maximum read units for this table.
scale_in_cooldown: (Optional, defualt 50) Cooldown value for Scale-in event
scale_out_cooldown: (Optional, defualt 50) Cooldown value for Scale-out event
target_utilization: (Optional, defualt 70) Target utilization
EOF
    type = map(number)
}

variable "autoscale_write_capacity" {
    description = "Flag to decide if Read Capacity autoscaling should be configured."
    type        = bool
}

variable "write_capacity" {
    description = "Number of minimum write units for this table."
    type        = number
}

variable "write_capacity_autoscaling" {
    description = <<EOF
The Configuration for Read capacity autoscaling:
max_capacity: (Required) Number of write read units for this table.
scale_in_cooldown: (Optional, defualt 50) Cooldown value for Scale-in event
scale_out_cooldown: (Optional, defualt 50) Cooldown value for Scale-out event
target_utilization: (Optional, defualt 70) Target utilization
EOF
    type = map(number)
}