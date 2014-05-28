require 'chef/mixin/shell_out'

module ManagedDNS
  class Helper
    include Chef::Mixin::ShellOut

    attr_reader :node

    def initialize(node)
      @node = node
    end

    def already_defined?
      check = shell_out("dig #{fqdn} | grep #{node['privateaddress']}")
      check.status == 0
    end

    def fqdn
      (hostname + domain).uniq.join('.')
    end

    def hostname
      node['hostname'].split('.')
    end

    def domain
      node['dynect']['zone'].split('.')
    end
  end
end
