variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "rg"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default     = "vm-lin-dns"
}

variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = "dns"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "westeurope"
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
  default     = "hub-vnet"
}

variable "virtual_network_name2" {
  description = "The name for the virtual network."
  default     = "app-vnet"
}

variable "virtual_network_name3" {
  description = "The name for the virtual network."
  default     = "local-vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.10.0/24"
}

variable "address_space2" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.20.0/24"
}

variable "address_space3" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.30.0/24"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/25"
}

variable "subnet_prefix2" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.20.0/25"
}

variable "subnet_prefix3" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.30.0/25"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D2s_v3"
}

variable "vm_win_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D2s_v3"
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "16.04-LTS"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "cloudadmin"
}

variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
}
