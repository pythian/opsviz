name "dashboard"
description "Dashboard Role"
run_list(
  "recipe[bb_monitor::kibana]",
  "recipe[bb_monitor::grafana]",
  "recipe[bb_monitor::graphite]",
  "recipe[bb_monitor::flapjack]",
  "recipe[bb_monitor::doorman]",
  "recipe[bb_monitor::sensu_server]",
  "recipe[bb_monitor::sensu_checks]",
  "recipe[bb_monitor::sensu_custom_checks]",
  "recipe[bb_monitor::sensu_stack_checks]",
  "recipe[nginx]",
  "recipe[bb_monitor::nginx]",
  "recipe[bb_monitor::logstash_agent]",
  "recipe[bb_monitor::sensu_client]"
)
