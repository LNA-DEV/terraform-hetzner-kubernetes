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
