variable "hcloud_token" {
  sensitive   = true # Requires terraform >= 0.14
  type        = string
  description = "Hetzner API-Token"
}

variable "kubeNodeCount" {
  type        = number
  description = "Count of Kubernetes Nodes"
  default     = 1
}
