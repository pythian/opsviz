=begin
#<
Removes a client from sensu by using a curl call to the sensu API
#>
=end

execute "remove sensu client" do
	command "curl -X DELETE #{node[:sensu][:api][:host]}:#{node[:sensu][:api][:port]}/client/#{node[:opsworks][:instance][:hostname]}.#{node[:opsworks][:instance][:layers][0]}.#{node[:opsworks][:stack][:name].downcase.gsub(' ','_')}"
	action :run
end
