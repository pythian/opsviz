%w(host password).each do |attribute|
  unless node[:bb_external][:logstash][:rabbitmq].has_key?(attribute)
    raise "Missing attribute bb_external.logstash.rabbitmq.#{attribute}"
  end
end


file_inputs = []

groups = ['all', node.name]
# It can run via chef solo on a single instance as well as capabilites for opsworks
groups += node[:opsworks][:instance][:layers] if node[:bb_external][:opsworks]

Chef::Log.info "Logstash file input groups"
groups.each do |group|
  next unless node[:bb_external][:logstash][:file_inputs].has_key?(group)
  if node[:bb_external][:logstash][:file_inputs][group].kind_of?(Array)
    file_inputs += node[:bb_external][:logstash][:file_inputs][group]
  else
    file_inputs << node[:bb_external][:logstash][:file_inputs][group]
  end
end

Chef::Log.info "Logstash inputs #{inputs}"

# Forward attributes to logstash cookbook in correct format
node.normal[:logstash][:agent][:outputs] = [{'rabbitmq' => node[:bb_external][:logstash][:rabbitmq]}]
node.normal[:logstash][:agent][:inputs] = file_inputs.map {|config| {"file" => config} }

Chef::Log.info "Logstash config #{node[:logstash]}"


include_recipe "logstash::default"
