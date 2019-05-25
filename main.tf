provider "azurerm" {
}

#resource "azurerm_resource_group" "rg" {
#  name     = "${var.resource_group}"
#  location = "${var.location}"
#}

resource "azurerm_availability_set" "avset" {
  name                         = "${var.dns_name}avset"
  location                     = "${data.azurerm_resource_group.test.location}"
  resource_group_name          = "${data.azurerm_resource_group.test.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  address_space       = ["${var.address_space}"]
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "${var.virtual_network_name2}"
  address_space       = ["${var.address_space2}"]
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  dns_servers         = ["10.0.10.4", "10.0.10.5"]
}

resource "azurerm_virtual_network" "vnet3" {
  name                = "${var.virtual_network_name3}"
  address_space       = ["${var.address_space3}"]
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  dns_servers         = ["10.0.10.4", "10.0.10.5"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.test.name}"
  address_prefix       = "${var.subnet_prefix}"
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${var.rg_prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet2.name}"
  resource_group_name  = "${data.azurerm_resource_group.test.name}"
  address_prefix       = "${var.subnet_prefix2}"
}

resource "azurerm_subnet" "subnet3" {
  name                 = "${var.rg_prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet3.name}"
  resource_group_name  = "${data.azurerm_resource_group.test.name}"
  address_prefix       = "${var.subnet_prefix3}"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic${count.index}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  location            = "${data.azurerm_resource_group.test.location}"
  count               = 2

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic2-1" {
  name                = "nic-vnet2-1"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  location            = "${data.azurerm_resource_group.test.location}"

  ip_configuration {
    name                          = "ipconfig-vnet2-1"
    subnet_id                     = "${azurerm_subnet.subnet2.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.test2.id}"
  }
}

resource "azurerm_network_interface" "nic3" {
  name                = "nic-vnet3"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  location            = "${data.azurerm_resource_group.test.location}"

  ip_configuration {
    name                          = "ipconfig-vnet3"
    subnet_id                     = "${azurerm_subnet.subnet3.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.test3.id}"
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "nic-vnet2"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  location            = "${data.azurerm_resource_group.test.location}"

  ip_configuration {
    name                          = "ipconfig-vnet2"
    subnet_id                     = "${azurerm_subnet.subnet2.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.hostname}${count.index}"
  location              = "${data.azurerm_resource_group.test.location}"
  resource_group_name   = "${data.azurerm_resource_group.test.name}"
  availability_set_id   = "${azurerm_availability_set.avset.id}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  count                 = 2

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name          = "osdisk${count.index}"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.hostname}${count.index}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${file("customdata.sh")}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      path     = "/home/cloudadmin/.ssh/authorized_keys"
      key_data = "ssh-rsa xxxxxx"
    }
  }
}

resource "azurerm_virtual_machine" "vm2" {
  name                  = "vm-lin-web01"
  location              = "${data.azurerm_resource_group.test.location}"
  resource_group_name   = "${data.azurerm_resource_group.test.name}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.nic2.id}"]

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name          = "vm-lin-web01"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "vm-lin-web01"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${file("cloud_init_web.sh")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/cloudadmin/.ssh/authorized_keys"
      key_data = "ssh-rsa XXXX"
    }
  }
}

resource "azurerm_virtual_machine" "vm2-1" {
  name                  = "vm-win-app"
  location              = "${data.azurerm_resource_group.test.location}"
  resource_group_name   = "${data.azurerm_resource_group.test.name}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.nic2-1.id}"]

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "osdisk-win-app-vnet"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "vm-win-app"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_public_ip" "test2" {
  name                = "PublicIp2"
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  domain_name_label   = "test-wim-vm-2"
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "test3" {
  name                = "PublicIp3"
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "test-wim-vm-3"
}

resource "azurerm_virtual_machine" "vm3" {
  name                  = "vm-win-rdp"
  location              = "${data.azurerm_resource_group.test.location}"
  resource_group_name   = "${data.azurerm_resource_group.test.name}"
  vm_size               = "${var.vm_win_size}"
  network_interface_ids = ["${azurerm_network_interface.nic3.id}"]

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "osdisk-win-vnet3"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "vm-win-rdp"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_virtual_network_peering" "test1" {
  name                      = "peer1to2"
  resource_group_name       = "${data.azurerm_resource_group.test.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet2.id}"
}

resource "azurerm_virtual_network_peering" "test2" {
  name                      = "peer2to1"
  resource_group_name       = "${data.azurerm_resource_group.test.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet2.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet.id}"
}

resource "azurerm_virtual_network_peering" "test3" {
  name                      = "peer3to1"
  resource_group_name       = "${data.azurerm_resource_group.test.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet3.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet.id}"
}

resource "azurerm_virtual_network_peering" "test4" {
  name                      = "peer1to3"
  resource_group_name       = "${data.azurerm_resource_group.test.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet3.id}"
}

resource "azurerm_dns_zone" "test_private" {
  name                             = "hub.mydomain.com"
  resource_group_name              = "${data.azurerm_resource_group.test.name}"
  zone_type                        = "Private"
  registration_virtual_network_ids = ["${azurerm_virtual_network.vnet.id}"]
}

resource "azurerm_dns_zone" "test_private2" {
  name                             = "app.mydomain.com"
  resource_group_name              = "${data.azurerm_resource_group.test.name}"
  zone_type                        = "Private"
  registration_virtual_network_ids = ["${azurerm_virtual_network.vnet2.id}"]
  resolution_virtual_network_ids   = ["${azurerm_virtual_network.vnet.id}"]
}

resource "azurerm_dns_zone" "test_private3" {
  name                             = "local.mydomain.com"
  resource_group_name              = "${data.azurerm_resource_group.test.name}"
  zone_type                        = "Private"
  registration_virtual_network_ids = ["${azurerm_virtual_network.vnet3.id}"]
  resolution_virtual_network_ids   = ["${azurerm_virtual_network.vnet.id}"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "dns-nsg"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  location            = "${data.azurerm_resource_group.test.location}"

  security_rule {
    name                       = "AllowInRdp"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.30.0/24"
  }

  security_rule {
    name                       = "AllowInVnets"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "10.0.0.0/8"
  }

  security_rule {
    name                       = "AllowOutVnets"
    priority                   = 1100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "10.0.0.0/8"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  subnet_id                 = "${azurerm_subnet.subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_subnet_network_security_group_association" "nsg2" {
  subnet_id                 = "${azurerm_subnet.subnet2.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_subnet_network_security_group_association" "nsg3" {
  subnet_id                 = "${azurerm_subnet.subnet3.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}
