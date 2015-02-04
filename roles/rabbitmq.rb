name "rabbitmq"
description "RabbitMQ Role"
run_list (
            "recipe[rabbitmq_cluster]", \
            "recipe[bb_monitor::logstash_agent]"
)
