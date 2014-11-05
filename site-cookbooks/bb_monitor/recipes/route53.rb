if node[:route53][:zone_id] && !node[:route53][:zone_id].empty?
  include_recipe "route53"

  stack_name = node[:opsworks][:stack][:name].downcase
  instance_dns = node[:opsworks][:instance][:public_dns_name] || node[:opsworks][:instance][:private_dns_name]

  node[:opsworks][:instance][:layers].each do |layer|
    log "Creating route53 record for instance #{node[:opsworks][:instance][:hostname]}"
    route53_record "route53 #{node[:opsworks][:instance][:hostname]}.#{stack_name}.#{node[:route53][:domain_name]}" do
      name  "#{node[:opsworks][:instance][:hostname]}.#{stack_name}.#{node[:route53][:domain_name]}"
      value instance_dns
      type  "CNAME"
      zone_id node[:route53][:zone_id]
      overwrite true
      action :create
    end

    # If this is the first instance in a layer and the layer has an elb add a record for that
    if node[:opsworks][:layers][layer][:instances].keys[0] == node[:opsworks][:instance][:hostname] && !node[:opsworks][:layers][layer]["elb-load-balancers"].empty?
      elb = node[:opsworks][:layers][layer]["elb-load-balancers"].first

      log "Creating route53 record for layer #{layer}.#{stack_name}.#{node[:route53][:domain_name]}"
      route53_record "route53 #{layer}" do
        name  "#{layer}.#{stack_name}.#{node[:route53][:domain_name]}"
        value elb[:dns_name]
        type  "CNAME"
        zone_id node[:route53][:zone_id]
        overwrite true
        action :create
      end

    end
  end
else
  log "Skipping route53 records because zone_id is not set"
end
