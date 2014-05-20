class Chef
  class Provider
    class ManagedDnsRecord < Chef::Provider

      def load_current_resource
        @current_resource ||= Chef::Resource::ManagedDnsRecord.new(new_resource.name)
      end

      def action_create
        require 'some_gem'
        api_credentials = new_resource.run_context.node['managed_dns']['credentials']
        SomeGem::Api.new(api_credentials)
        @current_resource.name
      end
    end
  end
end
