variable "Environment" {
    description = "Environment type"
    type = string
    default = "TEST"
}

variable "protocol" {
    description = "type of protocol"
    type = string
    default = "HTTP"
}

variable "protocol_port" {
    description = "Protocol port"
    type = string
    default = "80"
}

variable "weight_blue" {
    description = "weight for ALB routing to target group/blue"
    type = string
    default = "100"
}

variable "weight_green" {
    description = "weight for ALB routing to target group/green"
    type = string
    default = "0"
}

variable "vpc_public_subnets" {
    description = "Public subnet IDS"
    type = list(string)
}

variable "load_balancer_sg_id" {
    description = "Load balancer securtiy group"
    type = string
}

variable "vpc_id" {
    description = "vpc id"
    type = string
}