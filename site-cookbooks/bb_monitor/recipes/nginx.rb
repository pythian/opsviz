include_recipe 'nginx'
doorman_enabled = node["doorman"]["enabled"].equal? "true"
include_recipe 'bb_monitor::doorman' if doorman_enabled

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
