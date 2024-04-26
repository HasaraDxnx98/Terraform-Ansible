# ------------------------------- Azure Credentials Variable Definition -----------------------------------
# Azure Client ID
variable "azure_client_id" {
  type    = string
  default = ""
}

# Azure Client Secret
variable "azure_client_secret" {
  type    = string
  default = ""
}

# Azure Subscription ID
variable "azure_subscription_id" {
  type    = string
  default = ""
}

# Azure Tenant ID
variable "azure_tenant_id" {
  type    = string
  default = ""
}

# ------------------------- Security Rules Variable Definition ----------------------------------------
# Define variables for security rules
variable "security_rule" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

# ------------------------- Other Variable Definition ----------------------------------------
variable "location" {
  type        = string
  description = "Region"
  default     = "East US"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "instance_size_B4als" {
  type        = string
  description = "Azure instance size"
  default     = "Standard_B4als_v2"
}

variable "instance_size_B2als" {
  type        = string
  description = "Azure instance size"
  default     = "Standard_B2als_v2"
}

variable "company" {
  type    = string
  default = "sample"
}

variable "project" {
  type    = string
  default = "project"
}

variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type    = string
  default = "admin123"
}