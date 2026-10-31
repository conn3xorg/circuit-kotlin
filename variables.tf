variable "hosts" {
  type        = any
  description = "Hosts to configure: a map of names to addresses, or to host objects with an address and optional host_key, user, port, private_key_file or jump_hosts."
}

variable "ssh_user" {
  type        = string
  default     = "root"
  description = "User to log in as."
}

variable "ssh_port" {
  type        = number
  default     = 22
  description = "SSH port."
}

variable "ssh_private_key_file" {
  type        = string
  default     = null
  description = "Path to a private key. When null, Conn3x uses the SSH agent."
}

variable "ssh_known_hosts_file" {
  type        = string
  default     = null
  description = "known_hosts file to check host keys against. When null, ~/.ssh/known_hosts."
}

variable "ssh_become" {
  type        = bool
  default     = false
  description = "Run commands as root through sudo."
}

variable "kotlin_version" {
  type        = string
  default     = "2.4.21"
  description = "Kotlin compiler release to install, such as \"2.4.21\". Change checksum with it."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.kotlin_version))
    error_message = "kotlin_version must look like \"2.4.21\", without a leading v."
  }
}

variable "checksum" {
  type        = string
  default     = "7cc140e76daf416a0424a5557f99afd7ca89ebd463ea1101261e3e01c33e75cd"
  description = "SHA-256 of kotlin-compiler-VERSION.zip, from the .zip.sha256 file on the GitHub release. Change this with kotlin_version."

  validation {
    condition     = can(regex("^[0-9a-f]{64}$", var.checksum))
    error_message = "checksum must be a SHA-256 in lowercase hex."
  }
}
