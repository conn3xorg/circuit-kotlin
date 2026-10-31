output "kotlin_home" {
  description = "Directory of the installed Kotlin compiler on each host, by host name."
  value       = { for name in keys(var.hosts) : name => local.home }
}
