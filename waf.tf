resource "cloudflare_ruleset" "zone_level_waf" {
  zone_id     = data.cloudflare_zone.domain.id
  name        = "Ip Restriction Rule"
  description = "Block traffic not from allowed IP"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    action      = "block"
    expression  = "(http.host contains \"labchatops.online\" and not ip.src in {${join(" ", var.allowed_ips)}})"
    description = "Allow only specific IP for these subdomains"
    enabled     = true
  }
}
