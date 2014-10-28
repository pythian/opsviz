include_recipe 'nginx::ngx_lua_module'

# Need to fix the package for debian, real fix isn't merged yet into nginx repo https://github.com/miketheman/nginx/pull/268
lua_devel_package = resources(:package => "lua-devel")
lua_devel_package.package_name = "libluajit"

include_recipe 'nginx'

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
