include_recipe 'managed-dns::default'

managed_dns_record node['hostname'] do
  domain node['dynect']['zone']
  record_type 'A'
  ipaddress node['privateaddress']
  a_record node['hostname'].split('.')[0..-2].join(".")
  ttl 60
  action :create
  not_if { ManagedDNS::Helper.new(node).already_defined? }
end
