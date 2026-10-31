variable "port" {
  type    = number
  default = 2335
}

module "java" {
  source = "github.com/conn3xorg/circuit-java?ref=v0.1.0"

  hosts                = { box = "127.0.0.1" }
  ssh_port             = var.port
  ssh_private_key_file = "./id_ed25519"
  ssh_known_hosts_file = "./known_hosts"
}

module "kotlin" {
  source = "../.."

  hosts                = { box = "127.0.0.1" }
  ssh_port             = var.port
  ssh_private_key_file = "./id_ed25519"
  ssh_known_hosts_file = "./known_hosts"

  depends_on = [module.java]
}

output "kotlin_home" {
  value = module.kotlin.kotlin_home
}
