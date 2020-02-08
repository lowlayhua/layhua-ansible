# provider.tf
```
```
# managementnet.tf
```
# Create the managementnet network
resource "google_compute_network" "managementnet" {
  name                    = "managementnet"
  auto_create_subnetworks = "false"
}
# Create managementsubnet-us subnetwork
resource "google_compute_subnetwork" "managementsubnet-us" {
  name          = "managementsubnet-us"
  region        = "us-central1"
  network       = "${google_compute_network.managementnet.self_link}"
  ip_cidr_range = "10.130.0.0/20"
}
# Add a firewall rule to allow HTTP, SSH, and RDP traffic on managementnet
resource "google_compute_firewall" "managementnet-allow-http-ssh-rdp-icmp" {
  name    = "managementnet-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.managementnet.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
}
# Add the managementnet-us-vm instance
module "managementnet-us-vm" {
  source              = "./instance"
  instance_name       = "managementnet-us-vm"
  instance_zone       = "us-central1-a"
  instance_subnetwork = "${google_compute_subnetwork.managementsubnet-us.self_link}"
}
```
# mynetwork.tf
```
# Create the mynetwork network
resource "google_compute_network" "mynetwork" {
  name = "mynetwork"
  #RESOURCE properties go here
  auto_create_subnetworks = "true"
}
# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on mynetwork
resource "google_compute_firewall" "mynetwork_allow_http_ssh_rdp_icmp" {
  name    = "mynetwork-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.mynetwork.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
}
# Create the mynet-us-vm instance
module "mynet-us-vm" {
  source              = "./instance"
  instance_name       = "mynet-us-vm"
  instance_zone       = "us-central1-a"
  instance_subnetwork = "${google_compute_network.mynetwork.self_link}"
}
# Create the mynet-eu-vm" instance
module "mynet-eu-vm" {
  source              = "./instance"
  instance_name       = "mynet-eu-vm"
  instance_zone       = "europe-west1-d"
  instance_subnetwork = "${google_compute_network.mynetwork.self_link}"
}
```
# privatenet.tf
```
#Create privatenet network
resource "google_compute_network" "privatenet" {
  name                    = "privatenet"
  auto_create_subnetworks = false
}
# Create privatesubnet-us subnetwork
resource "google_compute_subnetwork" "privatesubnet-us" {
  name          = "privatesubnet-us"
  region        = "us-central1"
  network       = "${google_compute_network.privatenet.self_link}"
  ip_cidr_range = "172.16.0.0/24"
}
# Create privatesubnet-eu subnetwork
resource "google_compute_subnetwork" "privatesubnet-eu" {
  name          = "privatesubnet-eu"
  region        = "europe-west1"
  network       = "${google_compute_network.privatenet.self_link}"
  ip_cidr_range = "172.20.0.0/24"
}
# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on privatenet
resource "google_compute_firewall" "privatenet-allow-http-ssh-rdp-icmp" {
  name    = "privatenet-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.privatenet.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
}
# Add the privatenet-us-vm instance
module "privatenet-us-vm" {
  source              = "./instance"
  instance_name       = "privatenet-us-vm"
  instance_zone       = "us-central1-a"
  instance_subnetwork = "${google_compute_subnetwork.privatesubnet-us.self_link}"
}
```
