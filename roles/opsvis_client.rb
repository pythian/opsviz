name "opsvis_client"
description "OpsVis Client Role"
run_list(
  "recipe[bb_monitor::logstash_agent]",
  "recipe[bb_monitor::sensu_client]"
)
