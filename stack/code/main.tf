terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.12.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.1"
    }
  }
}

# Home Region Terraform Provider
provider "oci" {
  alias  = "home"
  region = local.home_region
  #region = "us-ashburn-1"
}

data "oci_core_services" "test_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_identity_compartment" "lab-sec-cmp" {
    compartment_id = data.oci_identity_tenancy.tenancy.id
    description = "Compartimento dos recursos do laboratório de segurança"
    name = "lab-seg-cmp"
}

resource "oci_core_vcn" "lab_seg_vcn" {
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    cidr_block = "172.16.13.0/24"
    display_name = "vcn-lab-seg"
    dns_label = "lab"
    is_ipv6enabled = false
}

resource "oci_core_subnet" "sn-priv" {
    cidr_block = "172.16.13.0/25"
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    display_name = "subnet-privada"
    dns_label = "priv"
    prohibit_public_ip_on_vnic = "true"
    route_table_id = oci_core_route_table.route_table_privada.id
    security_list_ids = [ oci_core_security_list.security_list_privada.id ]
}

resource "oci_core_subnet" "sn-pub" {
    cidr_block = "172.16.13.128/25"
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    display_name = "subnet-publica"
    dns_label = "pub"
    prohibit_public_ip_on_vnic = "false"
    route_table_id = oci_core_route_table.route_table_publica.id
    security_list_ids = [  oci_core_security_list.security_list_publica.id ]
}

resource "oci_core_route_table" "route_table_publica" {
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    display_name = "route-table-publica"
    route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_route_table" "route_table_privada" {
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    display_name = "route-table-privada"
    route_rules {
    destination       = data.oci_core_services.test_services.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_gateway.id
  }
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.natgw.id
  }
}

resource "oci_core_security_list" "security_list_publica" {
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    display_name = "security-list-publica"
    ingress_security_rules {
      protocol = "6"
      source = "0.0.0.0/0"
      tcp_options {
        max = "80"
        min = "80"
      }
    }
    egress_security_rules {
      destination = "172.16.13.0/24"
      protocol    = "All"
      stateless   = false
  }
}

resource "oci_core_security_list" "security_list_privada" {
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    display_name = "security-list-privada"
    ingress_security_rules {
      protocol = "6"
      source = "172.16.13.0/24"
      tcp_options {
        max = "80"
        min = "80"
      }
    }
    ingress_security_rules {
      protocol = "6"
      source = "172.16.13.0/24"
      tcp_options {
        max = "22"
        min = "22"
      }
    }
    egress_security_rules {
      destination      = data.oci_core_services.test_services.services[0]["cidr_block"]
      destination_type = "SERVICE_CIDR_BLOCK"
      protocol         = "all"
    }
    egress_security_rules {
      destination = "172.16.13.0/24"
      protocol    = "All"
      stateless   = false
  }
}

resource "oci_core_nat_gateway" "natgw" {
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    display_name = "nat-gateway"
}

resource "oci_core_internet_gateway" "internet_gateway" {
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    vcn_id = oci_core_vcn.lab_seg_vcn.id
    enabled = true
    display_name = "internet-gateway"
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = oci_identity_compartment.lab-sec-cmp.id
  services {
    service_id = data.oci_core_services.test_services.services[0]["id"]
  }
  vcn_id = oci_core_vcn.lab_seg_vcn.id
  display_name   = "service-gateway"
}

resource "oci_load_balancer_load_balancer" "load_balancer_01" {
  compartment_id = oci_identity_compartment.lab-sec-cmp.id
  display_name = "lb-lab-seg"
  shape = "flexible"
  subnet_ids = [ oci_core_subnet.sn-pub.id ]
    is_private = false
    shape_details {
        maximum_bandwidth_in_mbps = "100"
        minimum_bandwidth_in_mbps = "10"
    }
}

resource "oci_load_balancer_backend_set" "load_balancer_01_backend_set" {
    health_checker {
        protocol = "HTTP"
        port = "80"
        url_path = "/"
    }
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer_01.id
    name = "bs-server-http"
    policy = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "load_balancer_01_backend" {
    backendset_name = oci_load_balancer_backend_set.load_balancer_01_backend_set.name
    ip_address = oci_core_instance.instance_http01.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer_01.id
    port = 80
}

resource "oci_load_balancer_backend" "load_balancer_02_backend" {
    backendset_name = oci_load_balancer_backend_set.load_balancer_01_backend_set.name
    ip_address = oci_core_instance.instance_http02.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer_01.id
    port = 80
}

resource "oci_load_balancer_listener" "listener_http" {
    default_backend_set_name = oci_load_balancer_backend_set.load_balancer_01_backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer_01.id
    name = "listener-http"
    port = "80"
    protocol = "HTTP"
}

resource "oci_core_instance" "instance_http01" {
    availability_domain = data.oci_identity_availability_domain.ad.name
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    shape = "VM.Standard.E5.Flex"
    agent_config {
        are_all_plugins_disabled = false
    }
    create_vnic_details {
        display_name = "servidor-http01"
        hostname_label = "servidor-http01"
        subnet_id = oci_core_subnet.sn-priv.id
        assign_public_ip = false
    }
    display_name = "servidor-http01"
    source_details {
        source_id = var.instance_image_ocid[local.home_region]
        source_type = "image"
    }
    shape_config {
      ocpus = "1"
      memory_in_gbs = "8"
  }
  metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTA1O8yeocPs5MjopLtfRA2PzH+gbNtUm06H8I2YkPeavlFOWO4Xfkg+uNMWUltHguWQ60+E2H+YodIB1VDmVS9/efWWmEvaXi5a6s4GDVkaoNOcSSM4IME5yONBeKkx7JTNf9Jdg01p0yEYqb7rgmYSYrhWYz5Rmk/VXSj6IODBHkWPxVJruXnhcHvjDGw0+okj0F17raY/5FnQsRF0A9penjR6EHFrxSKQVDxzN7q4Pba3yLHwbhlqmaXgKl95lMSq5e8hNsHWCsrY4bazHvh3aKgPBnflCQ8TKFyptVQpUK0oumAQ7n2qSDmRRztvuTB6LChFLCXo55n354u8Dd9UYrbasLv43T59FgfOMIEgIPQhctThYcbLIYisQvA01KCAKmOWXrF9+JK43m4U14CP7aZYuH0Bq9e+Z2ZIRRiQbCoQOCme3RgNzpA49cE+L1ee3yKX4q7N2/m3jxbZO8wm3jRy6Y+xQWNEBqb7ipiz4mGiNww09hO/wMPyUqUvc="
    user_data = base64encode(file("./bootstrap"))
  } 
}

resource "oci_core_instance" "instance_http02" {
    availability_domain = data.oci_identity_availability_domain.ad.name
    compartment_id = oci_identity_compartment.lab-sec-cmp.id
    shape = "VM.Standard.E5.Flex"
    agent_config {
        are_all_plugins_disabled = false
    }
    create_vnic_details {
        display_name = "servidor-http02"
        hostname_label = "servidor-http02"
        subnet_id = oci_core_subnet.sn-priv.id
        assign_public_ip = false
    }
    display_name = "servidor-http02"
    source_details {
        source_id = var.instance_image_ocid[local.home_region]
        source_type = "image"
    }
    shape_config {
      ocpus = "1"
      memory_in_gbs = "8"
  }
  metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQDKomcFyMx342082qyaqdIU8a70HpnkrC6jOIh7JEsKeVvmfk/IQbfZWtAxeCJ08+pYL1p7O/fFGDNrxTHIez4IbQ/yXatWOrzDP+36x5QtKJII8ZA4/gZE3H/kWdp44XPPrpb8maqgQGA9VsRgKy3pmDwhGgyB6jXjQgiX+xyocbBKsrXF3nUM9qC9Z4Uf9ESrqiA0PQb/QP9cmakpUVFKunl++fxWdPLQSPbgTQl+UVoLCmw83gu4aYeSFWAZYgR+dieGckzPLRdHRzbMxsdjDsuQMNy/5jcmoIqxyWXve4HuaNXJNrQmHS+wiSK6RhuJxuT8rorsL4lbH6TPFCdVMJRMOmKDItS0EiP7WRy9FfLicXIKdF7DDMblXNC0zpkg5D5zun/pztQ8Neb3L4IQfODckcb4BTR6sZDU2xJ5vwstnlYdPPEXADL9RJMdMXYropZuZMuhuHKSv2srxZAdwuax4O5I57ytob+elqZoXINrRI5hL8fOe+HHWO840="
    user_data = base64encode(file("./bootstrap"))
  } 
}