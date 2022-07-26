data "http" "KubeInitMaster" {
  url = "https://raw.githubusercontent.com/LNA-DEV/terraform-hetzner-kubernetes/main/Scripts/KubeInitMaster.sh"
}

data "http" "KubeInitNode" {
  url = "https://raw.githubusercontent.com/LNA-DEV/terraform-hetzner-kubernetes/main/Scripts/KubeInitNode.sh"
}
