require 'chef/resource'

class Chef
  class Resource
    class  ManagedDnsRecord < Chef::Resource

      def initialize(name, run_context=nil)
        super
        @resource_name = :managed_dns_record
        @provider = Chef::Provider::ManagedDnsRecord
        @action = :create
        @allowed_actions = [:create]

        @record_type = 'A'
        @fqdn = name  # This is equivalent to setting :name_attribute => true
        @ttl = 3600
      end

      def fqdn(arg=nil)
        set_or_return(:fqdn, arg, kind_of: String)
      end

      def rdata(arg=nil)
        set_or_return(:rdata, arg, kind_of: String)
      end

      def ttl(arg=nil)
        set_or_return(:ttl, arg, kind_of: Integer)
      end
    end
  end
end



