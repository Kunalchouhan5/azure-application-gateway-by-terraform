variable "tenant_id" {
  type = string
  default = "" #required tenant id
}

variable "subscription_id" {
  type = string
  default = "" #required subscription id 
}

variable "rg" {
  type = string
  default = "App-test-rg"
  description = "Name of app rg"
}

variable "location" {
  type = string
  default = "Central India"
  description = "name of location"
}

variable "Vnet-name" {
  type = string
  default = "test-VNet"
  description = "Name of Vnet"
}

variable "address_space" {
  type = list(string)
  default = [ "10.1.0.0/16" ]
  description = "address space of virtual network"
}

variable "Subnet-name" {
  type = string
  default = "AppGw-subnet"
  description = "name of subnet"
}

variable "address_prefixes" {
  type = list(string)
  default = [ "10.1.0.0/24" ]
  description = "Value of address prefixes"
}

variable "public-ip" {
  type = string
  default = "Appgw-pip"
  description = "Application gateway frontend public IP"
}

variable "AppgW_name" {
  type = string
  default = "Appgw-01"
  description = "Application gateway name"
}