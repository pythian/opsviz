include_recipe "kibana"

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

%w[
  kibana
].each do |site|

  template "/etc/nginx/sites-available/#{site}" do
    source "#{site}.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[nginx]"
  end

  link "/etc/nginx/sites-enabled/#{site}" do
    to "/etc/nginx/sites-available/#{site}"
    notifies :restart, "service[nginx]"
  end
end

include_recipe "htpasswd"
htpasswd "/etc/nginx/graphite.htpasswd" do
  user node[:kibana][:user]
  password node[:kibana][:password]
end
