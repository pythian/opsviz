package "nginx" do
  action :install
end

service 'nginx' do
  supports :status => true, :restart => true
  action [ :enable, :start]
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

include_recipe "htpasswd"
htpasswd "/etc/nginx/graphite.htpasswd" do
  user node[:kibana][:user]
  password node[:kibana][:password]
end
