# TODO May break if a module with an older version uses the newest scripts

data "http" "KubeInitMaster" {
  url = "https://raw.githubusercontent.com/LNA-DEV/terraform-hetzner-kubernetes/main/Scripts/KubeInitMaster.sh"
}

data "http" "KubeInitNode" {
  url = "https://raw.githubusercontent.com/LNA-DEV/terraform-hetzner-kubernetes/main/Scripts/KubeInitNode.sh"
}
