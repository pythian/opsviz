=begin
#<
Wrapper around upstream grafana recipe to provide a custom default configuration
#>
=end

package 'mysql-client'

bash 'create grafana database' do
  code <<-EOS
    mysql -u#{node['grafana']['ini']['database']['user']} -p#{node['grafana']['ini']['database']['password']} -h#{node['grafana']['dbhost']} -e"CREATE DATABASE IF NOT EXISTS #{node['grafana']['ini']['database']['name']}"
  EOS
end




include_recipe 'grafana'

#temp fix
bash 'wait for grafana tables' do
  code <<-EOS
    sleep 10
  EOS
end

grafana_datasource 'graphite-cluster' do
  source(
    type: 'graphite',
    url: 'http://' + node[:graphite][:host] + ':8081',
    access: 'proxy'
  )
end

cookbook_file "/tmp/system-stats.json" do
  source "system-stats.json"
  action :create_if_missing
end

cookbook_file "/tmp/self-monitoring.json" do
  source "self-monitoring.json"
  action :create_if_missing
end

grafana_dashboard 'system-stats' do
  path '/tmp/system-stats.json'
  overwrite false
end

grafana_dashboard 'self-monitoring' do
  path '/tmp/self-monitoring.json'
  overwrite false
end

#template "#{node['grafana']['install_dir']}/app/dashboards/default.json" do
  #source 'system_stats.json.erb'
  #owner 'root'
  #group 'root'
  #mode '0664'
#end
