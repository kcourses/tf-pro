variable "name" {
  description = "Name of resource"
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "subnets" {
  type = list(string)
}

variable "asg_size" {
  type = object({
    max_size = number
    min_size = number
    desired_capacity = number
  })
  default = {
    max_size = 2
    min_size = 1
    desired_capacity = 1
  }
}