include_recipe "sensu::default"

# Build this in a way that it can run via chef solo on a single instance as well as capabilites for opsworks

if node[:bb_external][:sensu][:opsworks]
  sensu_client "#{node[:opsworks][:instance][:hostname]}.#{node[:opsworks][:instance][:layers][0]}.#{node[:opsworks][:stack][:name].downcase.gsub(' ','_')}" do
    address "#{node['opsworks']['instance']['private_ip']}"
    subscriptions node[:bb_external][:sensu][:subscriptions] + node[:opsworks][:instance][:layers]
    additional ({
      :stack => node[:opsworks][:stack][:name],
      :layer => node[:opsworks][:instance][:layers][0],
      :availability_zone => node[:opsworks][:instance][:availability_zone],
      :aws_instance_id => node[:opsworks][:instance][:aws_instance_id],
      :region => node[:opsworks][:instance][:region],
      :keepalive => {:handlers => node[:bb_external][:sensu][:keepalive_handler]}
    })
  end
else
  node_name = node[:bb_external][:sensu][:client_name] || node.name
  sensu_client node_name do
    address node.ipaddress
    subscriptions node[:bb_external][:sensu][:subscriptions]
  end
end

include_recipe "bb_external::sensu_plugins"

unless platform_family?("windows")
  template "/etc/sudoers.d/sensu" do
    source "sudoer_sensu.erb"
    owner "root"
    group "root"
    mode "0440"
  end
end

include_recipe "sensu::client_service"
