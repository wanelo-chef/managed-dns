#attribute :username, :kind_of => String
#attribute :password, :kind_of => String
#attribute :zone, :kind_of => String
#
#managed_dns_record 'log001.prod' do
#  fqdn 'log001.prod'
#  record_type 'A'
#  rdata '192.168.1.1'
#  ttl 600
#  zone 'prod'
#  action :create
#end
