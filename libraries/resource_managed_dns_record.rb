require 'chef/resource'

class Chef
  class Resource
    class ManagedDnsRecord < Chef::Resource

      attr_reader :record_type

      def initialize(name, run_context=nil)
        super
        @resource_name = :managed_dns_record
        @provider = Chef::Provider::ManagedDnsRecord::DnsMadeEasy
        @action = :create
        @allowed_actions = [:create]

        @run_context = run_context
        @record_type = 'A'
        @a_record = name  # This is equivalent to setting :name_attribute => true
        @ttl = 600
      end

      # defaults
      def domain(arg=nil)
        set_or_return(:domain, arg, kind_of: String)
      end

      def ipaddress(arg=nil)
        set_or_return(:ipaddress, arg, kind_of: String)
      end

      def a_record(arg=nil)
        set_or_return(:a_record, arg, kind_of: String)
      end

      def record_type(arg=nil)
        set_or_return(:record_type, arg, kind_of: String)
      end

      def ttl(arg=nil)
        set_or_return(:ttl, arg, kind_of: Integer)
      end
    end
  end
end



