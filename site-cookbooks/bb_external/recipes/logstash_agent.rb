%w(host password).each do |attribute|
  unless node[:bb_external][:logstash][:rabbitmq].has_key?(attribute)
    raise "Missing attribute bb_external.logstash.rabbitmq.#{attribute}"
  end
end

if node[:platform_family].include?("ubuntu")
  # Add the logstash user to the adm group so they can get the logs
  group "adm" do
    action :modify
    members "logstash"
    append true
  end
end

file_inputs = []

groups = ['all', node.name]
# It can run via chef solo on a single instance as well as capabilites for opsworks
groups += node[:opsworks][:instance][:layers] if node[:bb_external][:opsworks]

Chef::Log.info "Logstash file input #{groups}"
groups.each do |group|
  next unless node[:bb_external][:logstash][:file_inputs].has_key?(group)
  if node[:bb_external][:logstash][:file_inputs][group].kind_of?(Array)
    file_inputs += node[:bb_external][:logstash][:file_inputs][group]
  else
    file_inputs << node[:bb_external][:logstash][:file_inputs][group]
  end
end

file_patterns = []

file_inputs.map! do |input|
  input = input.to_hash
  if input.has_key?('pattern') && input.has_key?('type')
    file_patterns << {"grok" => {"type" => input['type'], 'pattern' => input['pattern']}}
    input.delete('pattern')
  end
  input
end
Chef::Log.info "Logstash inputs #{file_inputs}"
Chef::Log.info "Logstash patterns #{file_patterns}"

# Forward attributes to logstash cookbook in correct format
node.normal[:logstash][:agent][:outputs] = [{'rabbitmq' => node[:bb_external][:logstash][:rabbitmq]}]
node.normal[:logstash][:agent][:inputs] = file_inputs.map {|config| {"file" => config} }
node.normal[:logstash][:agent][:filters] = file_patterns + node[:bb_external][:logstash][:filters]

if node[:bb_external][:opsworks]
  node.normal[:logstash][:agent][:filters] << {
    "mutate" => {
      "add_field" => {
        "opsworks_stack"=> node[:opsworks][:stack][:name].downcase.gsub(' ','_'),
        "opsworks_layers"=> node[:opsworks][:instance][:layers].join(',')
      }
    }
  }
end

Chef::Log.info "Logstash config #{node[:logstash]}"


include_recipe "logstash::default"

template '/etc/init/logstash.conf' do
  source 'logstash.init.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables( :root => node[:bb_external][:logstash][:root] )
  notifies :restart, "service[logstash]"
end
