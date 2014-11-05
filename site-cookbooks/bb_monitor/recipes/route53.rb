if node[:route53_zone_id] && !node[:route53_zone_id].empty?
  include_recipe "route53"

  instance_dns = node[:opsworks][:instance][:public_dns_name] || node[:opsworks][:instance][:private_dns_name]

  node[:opsworks][:instance][:layers].each do |layer|
    route53_record "route53 #{node[:opsworks][:instance][:hostname]}.#{layer}" do
      name  "#{node[:opsworks][:instance][:hostname]}.#{layer}"
      value instance_dns
      type  "CNAME"
      zone_id node[:route53_zone_id]
      overwrite true
      action :create
    end

    # If this is the first instance in a layer and the layer has an elb add a record for that
    if node[:opsworks][:layers][layer][:instances].keys[0] == node[:opsworks][:instance][:hostname] && !node[:opsworks][:layers][layer]["elb-load-balancers"].empty?
      elb = node[:opsworks][:layers][layer]["elb-load-balancers"].first

      route53_record "route53 #{layer}" do
        name  "#{layer}"
        value elb[:dns_name]
        type  "CNAME"
        zone_id node[:route53_zone_id]
        overwrite true
        action :create
      end

    end
  end

end
