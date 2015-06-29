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

node.force_override[:elasticsearch][:custom_config]["http.enabled"] = true
node.force_override[:elasticsearch][:custom_config]["node.data"] = false
node.force_override[:elasticsearch][:custom_config]["node.master"] = true

include_recipe 'bb_elasticsearch:default'
