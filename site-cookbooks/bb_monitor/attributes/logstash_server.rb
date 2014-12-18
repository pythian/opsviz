include_attribute "bb_monitor::logstash_agent"

default[:bb_monitor][:logstash][:server][:elasticsearch_server] = ""
default[:bb_monitor][:logstash][:server][:threads] = "4"

default[:bb_monitor][:logstash][:server][:filters] = []
default[:bb_monitor][:logstash][:server][:statsd_output] = {}


# Forward attributes on to logstash recipe

normal[:logstash][:server][:filters] = node[:bb_monitor][:logstash][:server][:filters]

normal[:logstash][:server][:inputs] = [
  {
    "rabbitmq"=> {
      "exclusive"=> "false",
      "host"=> node[:bb_monitor][:logstash][:rabbitmq][:server],
      "user"=> node[:bb_monitor][:logstash][:rabbitmq][:user],
      "password"=> node[:bb_monitor][:logstash][:rabbitmq][:password],
      "exchange"=> node[:bb_monitor][:logstash][:rabbitmq][:exchange],
      "queue"=> node[:bb_monitor][:logstash][:rabbitmq][:queue],
      "threads"=> node[:bb_monitor][:logstash][:server][:threads],
    }
  }
]

normal[:logstash][:server][:outputs] = [
  {
    "elasticsearch_http"=> {
      "host"=> node[:bb_monitor][:logstash][:server][:elasticsearch_server],
      "replication"=> "async"
    },
    "statsd"=> node[:bb_monitor][:logstash][:server][:statsd_output],
  }
]
