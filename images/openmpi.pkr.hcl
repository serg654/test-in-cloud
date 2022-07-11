variable "token" {
  type = string
  default = "changeme"
  sensitive = true
}

variable "folder_id" {
  type = string
  default = "b1gt669hif8e053ife9j"
}

source "yandex" "openmpi_centos_8" {
  token = var.token
  folder_id = var.folder_id

  image_name = "openmpi-centos-8-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  image_family = "openmpi"
  image_description = "OpenMPI on Centos Stream 8"

  source_image_family = "centos-stream-8"
  ssh_username = "cloud-user"
  disk_type = "network-hdd"
  use_ipv4_nat = "true"
}

build {
  sources = ["source.yandex.openmpi_centos_8"]

  provisioner "file" {
    source = "nft_config"
    destination = "/dev/shm/main.nft"
  }

  provisioner "file" {
    source = "init.sh"
    destination = "/dev/shm/init.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /dev/shm/init.sh",
      "sudo /dev/shm/init.sh"
    ]
  }
}
