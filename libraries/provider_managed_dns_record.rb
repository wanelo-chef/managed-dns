class Chef
  class Provider
    class ManagedDnsRecord
      class DnsMadeEasy < Chef::Provider

        def load_current_resource
          return unless existing_record
          @current_resource = Chef::Resource::ManagedDnsRecord.new(new_resource.name, new_resource.run_context).tap do |r|
            r.domain new_resource.domain
            r.record_type existing_record['type']
            r.ipaddress existing_record['value']
            r.a_record existing_record['name'] if new_resource.record_type == 'A'
            r.ttl existing_record['ttl']
          end
        end

        def action_create
          unless exists?
            Chef::Log.info('dnsmadeeasy: Creating A Name Record')
            api.create_a_record(new_resource.domain, new_resource.a_record, new_resource.ipaddress, { 'ttl' => new_resource.ttl })
            new_resource.updated_by_last_action(true)
          end
        end

        def action_update
          if exists?
            return unless changed?
            Chef::Log.info('dnsmadeeasy: Changing A Name Record')
            api.update_record(new_resource.domain, existing_record['id'], new_resource.a_record, new_resource.record_type, new_resource.ipaddress, { 'ttl' => new_resource.ttl })
            new_resource.updated_by_last_action(true)
          else
            action_create
          end
        end

        private

        def exists?
          !!current_resource
        end

        def changed?
          return false unless current_resource
          [:domain, :ipaddress, :record_type, :name, :a_record, :ttl].any? do |field|
            new_resource.send(field) != current_resource.send(field)
          end
        end

        def existing_record
          @existing_record ||= domain_records.detect { |r| r['name'] == new_resource.a_record && r['type'] == new_resource.record_type }
        end

        def domain_records
          @records ||= api.records_for(new_resource.domain)['data']
        end

        def api
          api_credentials = new_resource.run_context.node['managed_dns']['dnsmadeeasy']['credentials']
          ::DnsMadeEasy.new(api_credentials['api_key'], api_credentials['secret_key'])
        end
      end
    end
  end
end
