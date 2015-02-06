name "rabbitmq"
description "RabbitMQ Role"
run_list(
  "recipe[rabbitmq_cluster]"
)
