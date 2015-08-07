include_recipe "logstash::default"

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
  notifies :restart, "service[logstash]"
end rescue NoMethodError
