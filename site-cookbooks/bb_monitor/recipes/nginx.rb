include_recipe 'nginx'

begin
  doorman_enabled = node["doorman"]["enabled"].eql? "true"
  Chef::Log.debug("node[\"doorman\"][\"enabled\"] is #{node['doorman']['enabled']}.  Configuring doorman.")
  Chef::Log.info("doorman_enabled is #{doorman_enabled}.  Configuring doorman.")
  include_recipe 'bb_monitor::doorman' if doorman_enabled
rescue
  Chef::Log.info("Couldn't find node[\"doorman\"][\"enabled\"].  Not configuring doorman.")
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end

template "/etc/nginx/sites-available/dashboard" do
  source "nginx/dashboard.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[nginx]"
end

link "/etc/nginx/sites-enabled/dashboard" do
  to "/etc/nginx/sites-available/dashboard"
  notifies :restart, "service[nginx]"
end
