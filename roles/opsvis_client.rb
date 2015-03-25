name "opsvis_client"
description "Opsvis Client Role. Installs Opsvis sensu client and logstash agent."
run_list(
  "recipe[bb_monitor::logstash_agent]",
  "recipe[bb_monitor::sensu_client]"
)
