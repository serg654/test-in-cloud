terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token = var.token
  cloud_id  = var.cluster_id
  folder_id = var.folder_id
  zone = "ru-central1-b"
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

data "yandex_compute_image" "openmpi-image" {
  folder_id = var.folder_id
  family = "openmpi"
}

resource "yandex_compute_instance" "server" {
  count = 2

  name = "vm-${count.index}"

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.openmpi-image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = count.index == 0 ? true : false
  }

  metadata = {
    user-data = "${file("vm_meta.txt")}"
  }
}

