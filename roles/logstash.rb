name "logstash"
description "LogStash Role"
run_list(
  "recipe[statsd]",
  "recipe[bb_monitor::logstash_server]"
)
