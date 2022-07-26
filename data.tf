data "http" "KubeInitMaster" {
  url = "https://github.com/LNA-DEV/terraform-hetzner-kubernetes/blob/main/Scripts/KubeInitMaster.sh"
}

data "http" "KubeInitNode" {
  url = "https://github.com/LNA-DEV/terraform-hetzner-kubernetes/blob/main/Scripts/KubeInitNode.sh"
}
