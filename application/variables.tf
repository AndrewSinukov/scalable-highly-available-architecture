variable "region" {
  default = "eu-west-1"
}

variable "remote_state_bucket" {
  description = "Bucket name for layer 1 remote state"
}

variable "remote_state_key" {
  description = "Key name for layer 1 remote state"
}

variable "ec2_instance_type" {
  description = "Ec2 instance type to launch"
}

variable "key_pair_name" {
  description = "Key pair to use for connect Ec2 instances"
  default     = "myEC2KeyPair"
}

variable "max_instance_size" {
  description = "Max number instances to launch"
}

variable "min_instance_size" {
  description = "Min number instances to launch"
}

variable "sns_email" {
  default = "example@gmail.com"
}

