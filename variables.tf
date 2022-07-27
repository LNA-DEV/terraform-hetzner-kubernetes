# Input

variable "hcloud_token" {
  sensitive   = true
  type        = string
  description = "Hetzner API-Token for the project you want the resources to be on"
}

variable "kubeNodeCount" {
  type        = number
  description = "Count of Kubernetes Nodes which are added in addition to the master node"
  default     = 1
}

variable "certifacteDomains" {
  type        = list(string)
  description = "A list of domains for certificates"
}

variable "loadBalancerDestinationPort" {
  type        = string
  description = "Destination Port of the LoadBalancer"
}

variable "kubeSecrets" {
  type        = string
  description = "Secrets which will be added to kubernetes"
  default = ""
}


# Output

output "kubeMasterIp" {
  value       = hcloud_server.kubeMaster.ipv4_address
  description = "The ip address of the master node"
}

output "kubeMasterNode0" {
  value       = hcloud_server.kubeNode["0"].ipv4_address
  description = "The ip address of the worker 0 node"
}

output "loadBalancerIp" {
  value       = hcloud_load_balancer.load_balancer.ipv4
  description = "The ip of the load balancer"
}
