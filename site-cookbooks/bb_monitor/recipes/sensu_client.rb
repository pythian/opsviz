include_recipe "sensu::default"

sensu_client "#{node[:opsworks][:instance][:hostname]}.#{node[:opsworks][:instance][:layers][0]}.#{node[:opsworks][:stack][:name].downcase.gsub(' ','_')}" do
  address node[:opsworks][:instance][:private_ip]
  subscriptions node[:bb_monitor][:sensu][:subscriptions]
  additional ({
    :stack => node[:opsworks][:stack][:name],
    :layer => node[:opsworks][:instance][:layers][0],
    :availability_zone => node[:opsworks][:instance][:availability_zone],
    :aws_instance_id => node[:opsworks][:instance][:aws_instance_id],
    :region => node[:opsworks][:instance][:region],
    :keepalive => {:handlers => node[:bb_monitor][:sensu][:default_check_handlers]}
  })
end

include_recipe "bb_external::sensu_plugins"

include_recipe "sensu::client_service"
service_resource = resources(:sensu_service => "sensu-client")
service_resource.service "sensu-client"

directory "/opt/sensu" do
  owner "sensu"
  action :create
end

template "/etc/sudoers.d/sensu" do
  source "sudoer_sensu.erb"
  cookbook "bb_external"
  owner "root"
  group "root"
  mode "0440"
end

# Update the path sensu uses to find the OpsWorks installed Ruby. This is
# required because plugin dependencies are installed to the OpsWorks ruby,
# not the normal system ruby.
ruby_block 'Add OpsWorks Ruby path to Sensu' do
  block do
    fn = '/etc/default/sensu'
    if File.exists?(fn)
      f = Chef::Util::FileEdit.new(fn)
      f.insert_line_if_no_match(/^\s*PATH=/, 'PATH=/usr/local/bin:$PATH')
      f.write_file
    end
  end
end

if File.exists?('/etc/apache2/sites-available')
	file '/etc/apache2/sites-available/sensu-server-stats' do
		mode 0655
		content 'Listen 127.0.0.1:8090'
	end

	bash 'Enable sensu-server-stats' do
		code <<-EOS
			a2enmod status
			a2ensite sensu-server-stats
		EOS
		not_if do
			File.exists?('/etc/apache2/sites-enabled/sensu-server-stats')
		end
	end
end
