dns_provider = node['managed_dns']['provider']
dns_provider_recipe = "managed-dns::#{dns_provider}"

include_recipe dns_provider_recipe
