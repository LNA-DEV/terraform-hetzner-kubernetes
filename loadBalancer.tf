# Load Balancer

resource "hcloud_load_balancer" "load_balancer" {
  name               = "load_balancer"
  load_balancer_type = "lb11"
  location           = "nbg1"
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.kubeNode["0"].id
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "https"
  destination_port = var.loadBalancerDestinationPort

  health_check {
    protocol = "tcp"
    port     = var.loadBalancerDestinationPort
    interval = 15
    timeout  = 10
    retries  = 3
  }

  http {
    certificates  = [hcloud_managed_certificate.managed_cert.id]
    redirect_http = true
  }
}

resource "hcloud_managed_certificate" "managed_cert" {
  name         = "managed_cert"
  domain_names = var.certifacteDomains
}
