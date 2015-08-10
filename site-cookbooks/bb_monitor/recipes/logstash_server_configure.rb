include_recipe "logstash::default"

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
end rescue NoMethodError
