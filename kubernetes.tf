resource "hcloud_server" "kubeMaster" {
  name        = "kubeMaster"
  server_type = "cpx11"
  image       = "ubuntu-20.04"
  location    = "nbg1"
  user_data   = replace(tostring(data.http.KubeInitMaster.body), "[REPLACE]", sum(["${var.kubeNodeCount}", 1]))

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
  user_data   = tostring(data.http.KubeInitNode.body)

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
