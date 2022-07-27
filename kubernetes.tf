resource "hcloud_server" "kubeMaster" {
  name        = "kubeMaster"
  server_type = "cpx11"
  image       = "ubuntu-20.04"
  location    = "nbg1"

  # Release
  user_data   = replace(tostring(data.http.KubeInitMaster.body), "[REPLACE]", sum(["${var.kubeNodeCount}", 1]))

  # Debug
  # user_data   = replace(file("./Scripts/KubeInitMaster.sh"), "[REPLACE]", sum(["${var.kubeNodeCount}", 1]))

  network {
    network_id = hcloud_network.kubeNetwork.id
    ip         = "10.0.1.1"
  }
}

resource "hcloud_server" "kubeNode" {
  count       = var.kubeNodeCount
  name        = "kubeNode${count.index}"
  server_type = "cpx11"
  image       = "ubuntu-20.04"
  location    = "nbg1"

  # Release
  user_data   = tostring(data.http.KubeInitNode.body)

  # Debug
  # user_data   = file("./Scripts/KubeInitNode.sh")

  network {
    network_id = hcloud_network.kubeNetwork.id
    ip         = replace("10.0.1.X", "X", sum(["${count.index}", 2]))
  }
}

resource "hcloud_network" "kubeNetwork" {
  name     = "kubeNetwork"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "kubeNetworkSubnet" {
  type         = "cloud"
  network_id   = hcloud_network.kubeNetwork.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/16"
}

# Load Balancer
resource "hcloud_load_balancer" "load_balancer" {
    name               = "load_balancer"
  load_balancer_type = "lb11"
  location           = "nbg1"
  target {
    type      = "server"
    server_id = hcloud_server.kubeNode["0"].id
  }
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
    load_balancer_id = hcloud_load_balancer.load_balancer.id
    protocol         = "https"
    destination_port = "30001"

    http {
        certificates = [hcloud_managed_certificate.managed_cert.id]
        redirect_http = true
    }
}

resource "hcloud_managed_certificate" "managed_cert" {
  name         = "managed_cert"
  domain_names = ["*.lna-dev.net"]
}