class Chef
  class Provider
    class ManagedDnsRecord
      class DnsMadeEasy < Chef::Provider

        def load_current_resource
          @current_resource ||= Chef::Resource::ManagedDnsRecord.new(new_resource.name, new_resource.run_context)
        end

        def action_create
          setup_gem

          if exists?
            Chef::Log.info('dnsmadeeasy: A Name Record already exists')
          else
            Chef::Log.info('dnsmadeeasy: Creating A Name Record')
            api.create_a_record(new_resource.domain, new_resource.a_record, new_resource.ipaddress, { "ttl" => new_resource.ttl })
          end
        end

        private

        def exists?
          raise if new_resource.domain.nil?
          records = api.find_record_id(new_resource.domain, new_resource.a_record, new_resource.record_type)
          Chef::Log.info("dnsmadeeasy: records: #{records.inspect}")
          !records.empty?
        end

        def setup_gem
          begin
            require 'dnsmadeeasy-rest-api'
          rescue LoadError
            error = "dnsmadeeasy: Missing gem 'dnsmadeeasy-rest-api'. Use the managed-dns::dnsmadeeasy recipe to install it first."
            Chef::Log.error(error)
            raise error
          end
        end

        def api
          api_credentials = new_resource.run_context.node['managed_dns']['dnsmadeeasy']['credentials']
          ::DnsMadeEasy.new(api_credentials['api_key'], api_credentials['secret_key'])
        end
      end
    end
  end
end
