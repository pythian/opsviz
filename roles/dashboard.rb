name "dashboard"
description "Dashboard Role"
run_list (
          "recipe[bb_monitor::kibana]", \
          "recipe[bb_monitor::grafana]", \
          "recipe[bb_monitor::sensu_server]", \
          "recipe[nginx]", \
          "recipe[bb_monitor::nginx]", \

          "recipe[bb_monitor::logstash_agent]", \

          "recipe[bb_monitor::sensu_client]"
)
