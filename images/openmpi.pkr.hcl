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

  image_name = join("-", ["openmpi-centos-8",formatdate("YYYYMMDDhhmmss", timestamp())])
  image_family = "openmpi"
  image_description = "OpenMPI on Centos Stream 8"

  source_image_family = "centos-stream-8"
  ssh_username = "cloud-user"
  disk_type = "network-hdd"
  use_ipv4_nat = "true"
}

build {
  sources = ["source.yandex.openmpi_centos_8"]

  provisioner "shell" {
    inline = [
               "sudo dnf update -y",
               "sudo dnf install -y openmpi.x86_64",
               "sudo dnf clean all"
             ]
  }
}
