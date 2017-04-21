# variables.tf
# https://forum.ethereum.org/discussion/2165/cloud-gpu-mining-with-amazon-aws-ec2
variable "aws" {
  description = "AWS provider settings"

  default = {
    access_key = ""
    profile    = ""
    region     = "us-east-1"
    secret_key = ""
  }
}

variable "cuda" {
  type        = "map"
  description = ""

  default = {
    pkg_url     = "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb"
    pkg_ext     = "deb"
    kernel_pkg  = "linux-generic"
    man_install = "dpkg -i"
    os_install  = "apt install -y"
    os_update   = "apt update"
  }
}

variable "instance" {
  type        = "map"
  description = "AWS instance default settings"

  default = {
    ami         = ""
    count       = "1"
    domain      = ""
    hostname    = ""
    key_name    = ""
    key_path    = ""
    network     = ""
    public      = ""
    root_delete = "true"
    subnet      = ""
    sg          = ""
    type        = "g2.xlarge2"
    user        = ""
    vpc         = ""
  }
}

variable "ethereum" {
  type        = "map"
  description = "Ethereum information"

  default = {
    key = "value"
  }
}
