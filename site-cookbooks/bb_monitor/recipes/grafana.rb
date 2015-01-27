=begin
#<
Wrapper around upstream grafana recipe to provide a custom default configuration
#>
=end

include_recipe 'grafana'

template "#{node['grafana']['install_dir']}/app/dashboards/default.json" do
  source 'system_stats.json.erb'
  owner 'root'
  group 'root'
  mode '0664'
end
