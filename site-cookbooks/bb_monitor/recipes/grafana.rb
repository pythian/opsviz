include_recipe 'grafana'

template "#{node['grafana']['install_dir']}/apps/dashboards/default.json" do
  source 'system_stats.json.erb'
  owner 'root'
  group 'root'
  mode '0664'
end
