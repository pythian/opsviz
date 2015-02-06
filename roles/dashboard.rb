name "dashboard"
description "Dashboard Role. Includes: kibana, grafana, graphite, flapjack, doorman, sensu_server and nginx."
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
  "recipe[bb_monitor::nginx]"
)
