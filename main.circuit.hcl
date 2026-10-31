locals {
  home = "/opt/kotlin/${var.kotlin_version}/kotlinc"
}

circuit "kotlin" {
  hosts = var.hosts

  ssh {
    user             = var.ssh_user
    port             = var.ssh_port
    private_key_file = var.ssh_private_key_file
    known_hosts_file = var.ssh_known_hosts_file
    become           = var.ssh_become
  }

  # Stops with a useful message rather than failing later inside kotlinc. It
  # looks again at apply because a Java step before this one may have just
  # put java there.
  step "java" {
    command {
      command = "command -v java >/dev/null || { echo 'kotlinc needs a java on the PATH. Apply circuit-java to this host first.' >&2; exit 1; }"
      unless  = "command -v java >/dev/null"
    }
  }

  step "tool" {
    for_each = ["curl", "unzip"]
    package {
      name = item.value
    }
  }

  step "dir" {
    for_each = ["/opt/kotlin", "/opt/kotlin/${var.kotlin_version}"]
    directory {
      path = item.value
    }
  }

  # The download step keeps the zip only if it matches the checksum.
  step "download" {
    download {
      url    = "https://github.com/JetBrains/kotlin/releases/download/v${var.kotlin_version}/kotlin-compiler-${var.kotlin_version}.zip"
      sha256 = var.checksum
      dest   = "/opt/kotlin/kotlin-compiler-${var.kotlin_version}.zip"
    }
  }

  step "unpack" {
    archive {
      src     = "/opt/kotlin/kotlin-compiler-${var.kotlin_version}.zip"
      dest    = "/opt/kotlin/${var.kotlin_version}"
      creates = "${local.home}/bin/kotlinc"
    }
  }

  step "link" {
    for_each = ["kotlin", "kotlinc"]
    link {
      path   = "/usr/local/bin/${item.value}"
      target = "${local.home}/bin/${item.value}"
    }
  }
}
