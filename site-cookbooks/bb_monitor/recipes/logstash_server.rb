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

# Just include the regular logstash agent recipe since attributes will drive the server config
include_recipe "bb_monitor::logstash_agent"
