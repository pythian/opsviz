=begin
#<
Adds attributes for logstash to prevent agent configuration
#>
=end



node.normal[:logstash][:server][:enabled] = true

# We don't want to have the server have an input and output to rabbitmq
node.force_override[:logstash][:agent][:outputs] = []

#We don't want double filtering either
node.force_override[:logstash][:agent][:filters] = []


include_recipe 'java'
# Just include the regular logstash agent recipe since attributes will drive the server config
include_recipe "bb_monitor::logstash_agent"

if node.normal[:logstash][:remote_config_files]
  node.normal[:logstash][:remote_config_files].each do |file_name, file_url|
    local_file_name = "/etc/logstash/conf.d/" + file_name
    remote_file local_file_name do
      source file_url
      owner 'logstash'
      group 'logstash'
      mode '0644'
      use_conditional_get true
      use_last_modified true
    end
  end
end rescue NoMethodError

node.force_override[:elasticsearch][:custom_config]["http.enabled"] = true
node.force_override[:elasticsearch][:custom_config]["node.data"] = false
node.force_override[:elasticsearch][:custom_config]["node.master"] = true

include_recipe 'bb_elasticsearch:default'
