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

cookbook_file "/tmp/download_from_s3.rb" do
    source "download_from_s3.rb"
    mode 0755
end

if node.normal[:remote_config_files][:logstash]
  node.normal[:remote_config_files][:logstash].each do |region, bucket, dest, source|
    bash "download config from s3" do
      code <<-EOF
        env -i /usr/local/bin/ruby /tmp/download_from_s3.rb -b #{bucket} -r #{region} -s #{source} -d #{dest}
      EOF
      notifies :restart, "service[logstash]"
    end
  end
end

node.force_override[:elasticsearch][:custom_config]["http.enabled"] = true
node.force_override[:elasticsearch][:custom_config]["node.data"] = false
node.force_override[:elasticsearch][:custom_config]["node.master"] = true

include_recipe 'bb_elasticsearch::default'
