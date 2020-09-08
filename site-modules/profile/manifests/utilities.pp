# Synchronize with NTP
class profile::utilities {
  ensure_packages(lookup('utilities', Array[String], 'unique'))
}
