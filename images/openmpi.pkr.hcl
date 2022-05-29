variable "token" {
  type = string
  default = "changeme"
  sensitive = true
}

variable "folder_id" {
  type = string
  default = "b1g3vbb75q8cdocujluk"
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

  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y openmpi nftables",
      "sudo dnf clean all",
      "sudo sed -r -i \"s|#include|include|\" /etc/sysconfig/nftables.conf",
      "sudo mv /dev/shm/main.nft /etc/nftables/main.nft",
      "sudo systemctl enable nftables",
      "sudo systemctl start nftables"
    ]
  }
}
