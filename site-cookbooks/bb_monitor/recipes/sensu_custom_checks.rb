node[:bb_monitor][:sensu][:custom_checks].each do |name, attributes|
  if attributes[:command].nil?
    Chef::Log.warn "Skipping custom sensu check #{name} as command is not set"
    next
  end

  if attributes[:type] == 'metric'
    chandlers = node[:bb_monitor][:sensu][:default_metric_handlers]
  else
    chandlers = node[:bb_monitor][:sensu][:default_check_handlers]
  end
  chandlers += attributes[:handlers] if attributes[:handlers].kind_of?(Array)

  csusbscribers = ["all"]
  csusbscribers += attributes[:subscribers] if attributes[:subscribers].kind_of?(Array)

  sensu_check name do
    type attributes[:type]
    command attributes[:command]
    handlers chandlers
    subscribers csusbscribers
    interval attributes[:interval]
    additional attributes[:additional]
  end
end
