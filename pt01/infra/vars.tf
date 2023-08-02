variable "ami" {
  type = string
}


variable "region_aws" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group" {
  type = string
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "group_name" {
  type = string
}

variable "producao" {
  type = bool
}
