resource_groups = {
  resource_group_1 = {
    name     = "[__resource_group_name__]"
    location = "eastus2"
    tags = {
      created_by   = "attuid@att.com"
      contact_dl   = "app_contact_dl@att.com"
      mots_id      = "19867"
      env          = "prod"
      automated_by = "SP-PROD-19867-CAP"
    }
  }
}
resource_group_name = "[__resource_group_name__]"
net_location        = null

virtual_networks = {
  virtualnetwork1 = {
    name                 = "eastus2-19867-prod-vnet-01"
    address_space        = ["10.0.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  }
}

vnet_peering = {}

subnets = {
  subnet1 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "eastus2-19867-prod-vnet-01"
    name              = "eastus2-19867-prod-vnet-01-web-snet-01"
    address_prefixes  = ["10.0.1.0/26"]
    service_endpoints = null
    pe_enable         = false
    delegation        = []
  },
  subnet2 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "eastus2-19867-prod-vnet-01"
    name              = "eastus2-19867-prod-vnet-01-app-snet-01"
    address_prefixes  = ["10.0.2.0/26"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet3 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "eastus2-19867-prod-vnet-01"
    name              = "eastus2-19867-prod-vnet-01-app-snet-02"
    address_prefixes  = ["10.0.3.0/26"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet4 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "eastus2-19867-prod-vnet-01"
    name              = "eastus2-19867-prod-vnet-01-db-snet-01"
    address_prefixes  = ["10.0.4.0/26"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet5 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "eastus2-19867-prod-vnet-01"
    name              = "eastus2-19867-prod-vnet-01-pls-snet-01"
    address_prefixes  = ["10.0.5.0/27"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
   subnet6 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "eastus2-19867-prod-vnet-01"
    name              = "eastus2-19867-prod-vnet-01-pe-snet-01"
    address_prefixes  = ["10.0.6.0/27"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  }
}

net_additional_tags = {
  iac          = "Terraform"
  env          = "prod"
  automated_by = "SP-PROD-19867-CAP"
}
resource_group_name = "[__resource_group_name__]"

network_security_groups = {
  nsg1 = {
    name                      = "cap-eastus2-prod-web-nsg-01"
    tags                      = { log_workspace = "[__log_analytics_name__]" }
    subnet_name               = "eastus2-19867-prod-vnet-01-web-snet-01"
    vnet_name                 = "eastus2-19867-prod-vnet-01"
    networking_resource_group = "[__networking_resource_group_name__]"
    security_rules = [
      {
        name                                         = "PLS-to-web"
        description                                  = "pls to web subnet"
        priority                                     = 100
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = null
        destination_port_ranges                      = ["22","443"]
        source_address_prefix                        = "10.0.5.0/27"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.1.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "Jump-to-web"
        description                                  = "Jump to web subnet"
        priority                                     = 105
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "22"
        destination_port_ranges                      = null
        source_address_prefix                        = "10.0.4.0/26"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.1.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Azure_Monitor"
        description                  = "Egress all traffic to Azure Monitor Service"
        priority                     = 200
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = null
        destination_port_ranges      = ["443","80"]
        source_address_prefix        = "10.0.1.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureMonitor"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Guest-And-Hybrid-Management"
        description                  = "Egress all traffic to Guest and Hybird Management"
        priority                     = 205
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "443"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.1.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "GuestAndHybridManagement"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-Active-Directory"
        description                  = "Egress all traffic to Azure Active Directory Service"
        priority                     = 210
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.1.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureActiveDirectory"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-Active-Backup"
        description                  = "Egress all traffic to Azure Backup"
        priority                     = 220
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.1.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureBackup"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "WEB-to-APP1"
        description                                  = "Web to app1"
        priority                                     = 225
        direction                                    = "Outbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "8443"
        destination_port_ranges                      = null
        source_address_prefix                        = "10.0.1.0/26"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.2.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "WEB-to-APP2"
        description                                  = "Web to app2"
        priority                                     = 230
        direction                                    = "Outbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "8443"
        destination_port_ranges                      = null
        source_address_prefix                        = "10.0.1.0/26"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.2.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-KV-Storage-Squid-PE"
        description                  = "Egress from app subnet to the Azure Key Vault Private Endpoint, Storage Private Endpoint(s), SQUID Proxy Private Endpoint"
        priority                     = 235
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.1.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "10.0.6.0/27"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "inbound-from-azure-load-balancer"
        description                  = "Allow inbound from Azure Load Balancer"
        priority                     = 4040
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "AzureLoadBalancer"
        source_address_prefixes      = null
        destination_address_prefix   = "VirtualNetwork"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Blocking-remaining-inbound-traffic"
        description                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                     = 4050
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "*"
        source_address_prefixes      = null
        destination_address_prefix   = "*"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Block-all-Internet-Traffic "
        description                  = "Block all outbound internet traffic"
        priority                     = 4040
        direction                    = "Outbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.1.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "Internet"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Blocking-remaining-outbound-traffic"
        description                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                     = 4050
        direction                    = "Outbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "*"
        source_address_prefixes      = null
        destination_address_prefix   = "*"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      }
    ]
  },
  nsg2 = {
    name                      = "cap-eastus2-prod-app-nsg-01"
    tags                      = { log_workspace = "[__log_analytics_name__]" }
    subnet_name               = "eastus2-19867-prod-vnet-01-app-snet-01"
    vnet_name                 = "eastus2-19867-prod-vnet-01"
    networking_resource_group = "[__networking_resource_group_name__]"
    security_rules = [
      {
        name                                         = "WEB-to-APP1"
        description                                  = "Web to app subnet"
        priority                                     = 100
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "8443"
        destination_port_ranges                      = null
        source_address_prefix                        = "10.0.1.0/26"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.2.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "PLS-to-APP1"
        description                                  = "PLS to app subnet"
        priority                                     = 105
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = null
        destination_port_ranges                      = ["22","443"]
        source_address_prefix                        = "10.0.5.0/27"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.2.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "Jump-to-web"
        description                                  = "Jump to web subnet"
        priority                                     = 110
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "22"
        destination_port_ranges                      = null
        source_address_prefix                        = "10.0.4.0/26"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.2.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Azure_Monitor"
        description                  = "Egress all traffic to Azure Monitor Service"
        priority                     = 200
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = null
        destination_port_ranges      = ["443","80"]
        source_address_prefix        = "10.0.2.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureMonitor"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Guest-And-Hybrid-Management"
        description                  = "Egress all traffic to Guest and Hybird Management"
        priority                     = 205
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "443"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.2.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "GuestAndHybridManagement"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-Active-Directory"
        description                  = "Egress all traffic to Azure Active Directory Service"
        priority                     = 210
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.2.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureActiveDirectory"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-Active-Backup"
        description                  = "Egress all traffic to Azure Backup"
        priority                     = 215
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.2.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureBackup"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-KV-Storage-Squid-PE"
        description                  = "Egress from app subnet to the Azure Key Vault Private Endpoint, Storage Private Endpoint(s), SQUID Proxy Private Endpoint"
        priority                     = 220
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.2.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "10.0.6.0/27"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "APP1-to-DBSubnet"
        description                  = "APP1 to DBSubnet"
        priority                     = 225
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "1524"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.2.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "10.0.4.0/27"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "inbound-from-azure-load-balancer"
        description                  = "Allow inbound from Azure Load Balancer"
        priority                     = 4040
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "AzureLoadBalancer"
        source_address_prefixes      = null
        destination_address_prefix   = "VirtualNetwork"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Blocking-remaining-inbound-traffic"
        description                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                     = 4050
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "*"
        source_address_prefixes      = null
        destination_address_prefix   = "*"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Block-all-Internet-Traffic "
        description                  = "Block all outbound internet traffic"
        priority                     = 4040
        direction                    = "Outbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.2.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "Internet"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Blocking-remaining-outbound-traffic"
        description                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                     = 4050
        direction                    = "Outbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "*"
        source_address_prefixes      = null
        destination_address_prefix   = "*"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      }
    ]
  },
  nsg3 = {
    name                      = "cap-eastus2-prod-app-nsg-02"
    tags                      = { log_workspace = "[__log_analytics_name__]" }
    subnet_name               = "eastus2-19867-prod-vnet-01-app-snet-02"
    vnet_name                 = "eastus2-19867-prod-vnet-01"
    networking_resource_group = "[__networking_resource_group_name__]"
    security_rules = [
      {
        name                                         = "WEB-to-APP2"
        description                                  = "Web to app subnet"
        priority                                     = 100
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "8443"
        destination_port_ranges                      = null
        source_address_prefix                        = "10.0.1.0/26"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.3.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "PLS-to-APP2"
        description                                  = "PLS to app subnet"
        priority                                     = 105
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = null
        destination_port_ranges                      = ["22","443"]
        source_address_prefix                        = "10.0.5.0/27"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.3.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "Jump-to-web"
        description                                  = "Jump to web subnet"
        priority                                     = 110
        direction                                    = "Inbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "22"
        destination_port_ranges                      = null
        source_address_prefix                        = "10.0.4.0/26"
        source_address_prefixes                      = null
        destination_address_prefix                   = "10.0.3.0/26"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Azure_Monitor"
        description                  = "Egress all traffic to Azure Monitor Service"
        priority                     = 200
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = null
        destination_port_ranges      = ["443","80"]
        source_address_prefix        = "10.0.3.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureMonitor"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Guest-And-Hybrid-Management"
        description                  = "Egress all traffic to Guest and Hybird Management"
        priority                     = 205
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "443"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.3.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "GuestAndHybridManagement"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-Active-Directory"
        description                  = "Egress all traffic to Azure Active Directory Service"
        priority                     = 210
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.3.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureActiveDirectory"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-Active-Backup"
        description                  = "Egress all traffic to Azure Backup"
        priority                     = 220
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.3.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "AzureBackup"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "app-to-Azure-KV-Storage-Squid-PE"
        description                  = "Egress from app subnet to the Azure Key Vault Private Endpoint, Storage Private Endpoint(s), SQUID Proxy Private Endpoint"
        priority                     = 225
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.3.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "10.0.6.0/27"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "APP1-to-DBSubnet"
        description                  = "APP1 to DBSubnet"
        priority                     = 230
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "1524"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.3.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "10.0.4.0/27"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "inbound-from-azure-load-balancer"
        description                  = "Allow inbound from Azure Load Balancer"
        priority                     = 4040
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "AzureLoadBalancer"
        source_address_prefixes      = null
        destination_address_prefix   = "VirtualNetwork"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Blocking-remaining-inbound-traffic"
        description                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                     = 4050
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "*"
        source_address_prefixes      = null
        destination_address_prefix   = "*"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Block-all-Internet-Traffic "
        description                  = "Block all outbound internet traffic"
        priority                     = 4040
        direction                    = "Outbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "10.0.3.0/26"
        source_address_prefixes      = null
        destination_address_prefix   = "Internet"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                         = "Blocking-remaining-outbound-traffic"
        description                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                     = 4050
        direction                    = "Outbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "*"
        source_address_prefixes      = null
        destination_address_prefix   = "*"
        destination_address_prefixes = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      }
    ]
  },
  nsg4 = {
    name                      = "cap-eastus2-prod-pls-nsg-01"
    tags                      = { log_workspace = "[__log_analytics_name__]" }
    subnet_name               = "eastus2-19867-prod-vnet-01-pls-snet-01"
    vnet_name                 = "eastus2-19867-prod-vnet-01"         ## no need since subnet name used
    networking_resource_group = "[__networking_resource_group_name__]"
    security_rules = [
      {
        name                                         = "Block_Internet_aks"
        description                                  = "Block all Internet Traffic"
        priority                                     = 4050
        direction                                    = "Outbound"
        access                                       = "Deny"
        protocol                                     = "*"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "*"
        destination_port_ranges                      = null
        source_address_prefix                        = "*"
        source_address_prefixes                      = null
        destination_address_prefix                   = "*"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "Block_All_Traffic_aks"
        description                                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                                     = 4050
        direction                                    = "Inbound"
        access                                       = "Deny"
        protocol                                     = "*"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "*"
        destination_port_ranges                      = null
        source_address_prefix                        = "*"
        source_address_prefixes                      = null
        destination_address_prefix                   = "*"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "Allow-outbound-traffic_aks"
        description                                  = "Allow all remaining outbound traffic"
        priority                                     = 4000
        direction                                    = "Outbound"
        access                                       = "Allow"
        protocol                                     = "*"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "*"
        destination_port_ranges                      = null
        source_address_prefix                        = "*"
        source_address_prefixes                      = null
        destination_address_prefix                   = "VirtualNetwork"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      }
    ]
  },
  nsg5 = {
    name                      = "cap-eastus2-prod-pe-nsg-01"
    tags                      = { log_workspace = "[__log_analytics_name__]" }
    subnet_name               = "eastus2-19867-prod-vnet-01-pe-snet-01"
    vnet_name                 = "eastus2-19867-prod-vnet-01"         ## no need since subnet name used
    networking_resource_group = "[__networking_resource_group_name__]"
    security_rules = [
      {
        name                                         = "Block_Internet_aks"
        description                                  = "Block all Internet Traffic"
        priority                                     = 4050
        direction                                    = "Outbound"
        access                                       = "Deny"
        protocol                                     = "*"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "*"
        destination_port_ranges                      = null
        source_address_prefix                        = "*"
        source_address_prefixes                      = null
        destination_address_prefix                   = "*"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "Block_All_Traffic_aks"
        description                                  = "Block all remaining inbound traffic that does not match any previous rule"
        priority                                     = 4050
        direction                                    = "Inbound"
        access                                       = "Deny"
        protocol                                     = "*"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "*"
        destination_port_ranges                      = null
        source_address_prefix                        = "*"
        source_address_prefixes                      = null
        destination_address_prefix                   = "*"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      },
      {
        name                                         = "Allow-outbound-traffic_aks"
        description                                  = "Allow all remaining outbound traffic"
        priority                                     = 4000
        direction                                    = "Outbound"
        access                                       = "Allow"
        protocol                                     = "*"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "*"
        destination_port_ranges                      = null
        source_address_prefix                        = "*"
        source_address_prefixes                      = null
        destination_address_prefix                   = "VirtualNetwork"
        destination_address_prefixes                 = null
        source_application_security_group_names      = []
        destination_application_security_group_names = []
      }
    ]
  }
}

nsg_additional_tags = {
  iac          = "Terraform"
  env          = "prod"
  automated_by = "SP-PROD-19867-CAP"
}
locals {
  linux_image_ids = {
    "cap-eastus2-prod-app-01-vm-01" = "/subscriptions/02b9662b-8e86-467f-a7d4-51d37caed8ab/resourceGroups/19867-eastus2-nprd-devops-rg/providers/Microsoft.Compute/galleries/19867_eastus2_nprd_devops_sig/images/appserver/versions/1.0.4"
    "cap-eastus2-prod-app-01-vm-02" = "/subscriptions/02b9662b-8e86-467f-a7d4-51d37caed8ab/resourceGroups/19867-eastus2-nprd-devops-rg/providers/Microsoft.Compute/galleries/19867_eastus2_nprd_devops_sig/images/appserver/versions/1.0.4"
    "cap-eastus2-prod-app-01-vm-03" = "/subscriptions/02b9662b-8e86-467f-a7d4-51d37caed8ab/resourceGroups/19867-eastus2-nprd-devops-rg/providers/Microsoft.Compute/galleries/19867_eastus2_nprd_devops_sig/images/appserver/versions/1.0.4"
    "cap-eastus2-prod-app-01-vm-04" = "/subscriptions/02b9662b-8e86-467f-a7d4-51d37caed8ab/resourceGroups/19867-eastus2-nprd-devops-rg/providers/Microsoft.Compute/galleries/19867_eastus2_nprd_devops_sig/images/appserver/versions/1.0.4"
    "cap-eastus2-prod-app-01-vm-05" = "/subscriptions/02b9662b-8e86-467f-a7d4-51d37caed8ab/resourceGroups/19867-eastus2-nprd-devops-rg/providers/Microsoft.Compute/galleries/19867_eastus2_nprd_devops_sig/images/appserver/versions/1.0.4"
    "cap-eastus2-prod-app-01-vm-06" = "/subscriptions/02b9662b-8e86-467f-a7d4-51d37caed8ab/resourceGroups/19867-eastus2-nprd-devops-rg/providers/Microsoft.Compute/galleries/19867_eastus2_nprd_devops_sig/images/appserver/versions/1.0.4"
  }
}

# Diagnostics Extensions
variable "todoapp_image_id" {
  type        = string
  description = "The image id"
  default     = null
}
resource_group_name = "cap-eastus2-prod-core-rg-01"

load_balancers = {
  loadbalancer1 = {
    name = "cap-eastus2-prod-web-lb-01"
    sku  = "Standard"
    frontend_ips = [
      {
        name                      = "prodweb01-lbfip"
        subnet_name               = "eastus2-19867-prod-vnet-01-web-snet-01"
        vnet_name                 = "eastus2-19867-prod-vnet-01"
        networking_resource_group = "[__networking_resource_group_name__]"
        static_ip                 = null # "10.0.1.4" #(Optional) Set null to get dynamic IP 
        zones                     = null
      }
    ]
    backend_pool_names = ["prodweb01-lbbep"]
    enable_public_ip   = false # set this to true to if you want to create public load balancer
    public_ip_name     = null
  },
  loadbalancer2 = {
    name = "cap-eastus2-prod-app-lb-01"
    sku  = "Standard"
    frontend_ips = [
      {
        name                      = "prodapp01-lbfip"
        subnet_name               = "eastus2-19867-prod-vnet-01-app-snet-01"
        vnet_name                 = "eastus2-19867-prod-vnet-01"
        networking_resource_group = "[__networking_resource_group_name__]"
        static_ip                 = null # "10.0.1.4" #(Optional) Set null to get dynamic IP 
        zones                     = null
      }
    ]
    backend_pool_names = ["prodapp01-lbbep"]
    enable_public_ip   = false # set this to true to if you want to create public load balancer
    public_ip_name     = null
  },
  loadbalancer3 = {
    name = "cap-eastus2-prod-app-lb-02"
    sku  = "Standard"
    frontend_ips = [
      {
        name                      = "prodapp02-lbfip"
        subnet_name               = "eastus2-19867-prod-vnet-01-app-snet-02"
        vnet_name                 = "eastus2-19867-prod-vnet-01"
        networking_resource_group = "[__networking_resource_group_name__]"
        static_ip                 = null # "10.0.1.4" #(Optional) Set null to get dynamic IP 
        zones                     = null
      }
    ]
    backend_pool_names = ["prodapp02-lbbep"]
    enable_public_ip   = false # set this to true to if you want to create public load balancer
    public_ip_name     = null
  }
}

load_balancer_rules = {
  loadbalancerrules1 = {
    name                      = "prodhttps22-lbprb"
    lb_key                    = "loadbalancer1"
    frontend_ip_name          = "prodweb01-lbfip"
    backend_pool_name         = "prodweb01-lbbep"
    lb_protocol               = null
    lb_port                   = "22"
    probe_port                = "22"
    backend_port              = "22"
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  },
  loadbalancerrules2 = {
    name                      = "prodhttps443-lbprb1"
    lb_key                    = "loadbalancer2"
    frontend_ip_name          = "prodapp01-lbfip"
    backend_pool_name         = "prodapp01-lbbep"
    lb_protocol               = null
    lb_port                   = "443"
    probe_port                = "443"
    backend_port              = "443"
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  },
  loadbalancerrules3 = {
    name                      = "prodhttps1524-lbprb1"
    lb_key                    = "loadbalancer2"
    frontend_ip_name          = "prodapp01-lbfip"
    backend_pool_name         = "prodapp01-lbbep"
    lb_protocol               = null
    lb_port                   = "1524"
    probe_port                = "1524"
    backend_port              = "1524"
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  },
  loadbalancerrules4 = {
    name                      = "prodhttps443-lbprb2"
    lb_key                    = "loadbalancer3"
    frontend_ip_name          = "prodapp02-lbfip"
    backend_pool_name         = "prodapp02-lbbep"
    lb_protocol               = null
    lb_port                   = "443"
    probe_port                = "443"
    backend_port              = "443"
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  },
  loadbalancerrules5 = {
    name                      = "prodhttps1524-lbprb2"
    lb_key                    = "loadbalancer3"
    frontend_ip_name          = "prodapp02-lbfip"
    backend_pool_name         = "prodapp02-lbbep"
    lb_protocol               = null
    lb_port                   = "1524"
    probe_port                = "1524"
    backend_port              = "1524"
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  }
}

load_balancer_nat_pools = {}

lb_outbound_rules = {}

load_balancer_nat_rules = {}

lb_additional_tags = {
  iac          = "Terraform"
  env          = "prod"
  automated_by = "SP-PROD-19867-CAP"
}
