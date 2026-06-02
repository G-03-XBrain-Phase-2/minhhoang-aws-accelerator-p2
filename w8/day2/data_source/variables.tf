variable "allowed_ports" {
  type = list(number)

  default = [80, 443, 32]
}
