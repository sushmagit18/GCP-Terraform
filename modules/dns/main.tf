resource "google_dns_managed_zone" "example_zone" {
  name        = "example-zone"
  dns_name    = "mygcp-exampleproject.com."
  description = "Managed zone for my example project."
}

resource "google_compute_global_address" "example_ip" {
  name = "example-ip"
}

resource "google_dns_record_set" "example_a_record" {
  name         = "mygcp-exampleproject.com."
  managed_zone = google_dns_managed_zone.example_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.example_ip.address]
}