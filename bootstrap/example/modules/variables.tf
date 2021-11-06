variable "tags" {
  type = map(string)
  default = { }
}

variable "instance_type" {
}

variable "cidr_block" {

}

variable "instance_count" {
  type = number
}
