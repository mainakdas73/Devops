variable "rgname" {
  description = "Name of the resource group"
  type        = string
}
variable "location" {
  description = "Location of the resource group"
  type        = string
}
variable "vnetname" {
  description = "Name of the virtual network"
  type        = string
}
variable "address_space" {
  description = "Vnet Address space value"
  type        = list(string)
}
variable "nsgrules" {
  type = list(map(any))
  default = [{ "rulename" = "Allow-SSH", "priority" = "100", "dport" = "22", "protocol" = "Tcp" },
    { "rulename" = "httprule", "priority" = "101", "dport" = "80", "protocol" = "Tcp" },
    { "rulename" = "httpsrule", "priority" = "102", "dport" = "443", "protocol" = "Tcp" },
    { "rulename" = "dbrule", "priority" = "103", "dport" = "3306", "protocol" = "Tcp" },

  ]
}