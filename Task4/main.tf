terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id = "b1gql7euj1v1qc9pn0gk"
  folder_id = "b1grfikcp5as92ttdh2d"
  zone      = "ru-central1-a"             # Указание региона провайдера
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "self-service-app-vm" {
  name = "self-service-app-vm-disk"
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 15
}

resource "yandex_compute_disk" "self-service-api-vm" {
  name = "self-service-api-vm-disk"
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 15
}

resource "yandex_compute_disk" "self-service-db-vm" {
  name = "self-service-db-vm-disk"
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 15
}

resource "yandex_compute_disk" "clickhouse-server-vm" {
  name = "clickhouse-server-vm-disk"
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 30
}

resource "yandex_compute_instance" "self-service-app-vm" {
  name = "self-service-app-vm"
  zone = "ru-central1-a"                  # Регион, в котором будет создана VM

  // Вложенный блок resources определяет ресурсы виртуальной машины
  resources {
    cores  = 2                            # Количество ядер процессора
    memory = 2                            # Объём оперативной памяти (Gb)
  }

  // Вложенный блок boot_disk связывает диск с виртуальной машиной, где
  // используем ID диска, созданного в корневом блоке
  boot_disk {
    disk_id = yandex_compute_disk.self-service-app-vm.id
  }

  // Блок описания сетевого интерфейса network_interface
  network_interface {
    subnet_id = "e9bap4kjnnad1i9m3vql" # Идентификатор подсети
    nat       = true                       # Включение NAT для выхода в интернет
  }
}

resource "yandex_compute_instance" "self-service-api-vm" {
  name = "self-service-api-vm"
  zone = "ru-central1-a"                  # Регион, в котором будет создана VM

  // Вложенный блок resources определяет ресурсы виртуальной машины
  resources {
    cores  = 2                            # Количество ядер процессора
    memory = 2                            # Объём оперативной памяти (Gb)
  }

  // Вложенный блок boot_disk связывает диск с виртуальной машиной, где
  // используем ID диска, созданного в корневом блоке
  boot_disk {
    disk_id = yandex_compute_disk.self-service-api-vm.id
  }

  // Блок описания сетевого интерфейса network_interface
  network_interface {
    subnet_id = "e9bap4kjnnad1i9m3vql" # Идентификатор подсети
    nat       = true                       # Включение NAT для выхода в интернет
  }
}

resource "yandex_compute_instance" "self-service-db-vm" {
  name = "self-service-db-vm"
  zone = "ru-central1-a"                  # Регион, в котором будет создана VM

  // Вложенный блок resources определяет ресурсы виртуальной машины
  resources {
    cores  = 2                            # Количество ядер процессора
    memory = 2                            # Объём оперативной памяти (Gb)
  }

  // Вложенный блок boot_disk связывает диск с виртуальной машиной, где
  // используем ID диска, созданного в корневом блоке
  boot_disk {
    disk_id = yandex_compute_disk.self-service-db-vm.id
  }

  // Блок описания сетевого интерфейса network_interface
  network_interface {
    subnet_id = "e9bap4kjnnad1i9m3vql" # Идентификатор подсети
    nat       = true                       # Включение NAT для выхода в интернет
  }
}

resource "yandex_compute_instance" "clickhouse-server-vm" {
  name = "clickhouse-server-vm"
  zone = "ru-central1-a"                  # Регион, в котором будет создана VM

  // Вложенный блок resources определяет ресурсы виртуальной машины
  resources {
    cores  = 2                            # Количество ядер процессора
    memory = 2                            # Объём оперативной памяти (Gb)
  }

  // Вложенный блок boot_disk связывает диск с виртуальной машиной, где
  // используем ID диска, созданного в корневом блоке
  boot_disk {
    disk_id = yandex_compute_disk.clickhouse-server-vm.id
  }

  // Блок описания сетевого интерфейса network_interface
  network_interface {
    subnet_id = "e9bap4kjnnad1i9m3vql" # Идентификатор подсети
    nat       = true                       # Включение NAT для выхода в интернет
  }
}