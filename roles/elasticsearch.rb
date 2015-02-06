name "elasticsearch"
description "ElasticSearch Role"
run_list(
  "recipe[bb_elasticsearch]",
  "recipe[statsd]",
  "recipe[bb_monitor::logstash_server]",
  "recipe[bb_monitor::logstash_agent]"
)
