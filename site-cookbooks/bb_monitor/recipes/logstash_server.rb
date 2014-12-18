# We don't want to have the server have an input and output to rabbitmq
node.force_override[:logstash][:agent][:outputs] = []

# Just include the regular logstash agent recipe since attributes will drive the server config
include_recipe "bb_monitor::logstash_agent"
