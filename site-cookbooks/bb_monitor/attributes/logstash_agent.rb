normal[:logstash][:version] = "1.4"
#TODO: Don't run as root but rather make sure logstash user has access to all logs
default[:bb_monitor][:logstash][:root] = true

default[:bb_monitor][:logstash][:rabbitmq][:server] = ""
default[:bb_monitor][:logstash][:rabbitmq][:password] = ""
default[:bb_monitor][:logstash][:rabbitmq][:user] = "logstash_internal"
default[:bb_monitor][:logstash][:rabbitmq][:queue] = "incoming_logs"
default[:bb_monitor][:logstash][:rabbitmq][:exchange] = "logstash"
default[:bb_monitor][:logstash][:rabbitmq][:exchange_type] = "direct"

# Forward attributes on to logstash recipe
normal[:logstash][:agent][:inputs]  = [
  {
    "file" => {
      "type"=> "sensu",
      "path"=> "/var/log/sensu/*.log",
      "codec"=> "json",
    }
  },
  {
    "file" => {
      "type"=> "doorman",
      "path"=> "/var/log/doorman/current",
    }
  },
  {
    "file" => {
      "type"=> "nginx_access",
      "path"=> "/var/log/nginx/access.log",
    }
  },
  {
    "file" => {
      "type"=> "nginx_error",
      "path"=> "/var/log/nginx/error.log",
    }
  },
  {
    "file" => {
      "type"=> "elasticsearch",
      "path"=> "/usr/local/var/log/elasticsearch/*.log",
    }
  },
  {
    "file" => {
      "type"=> "carbon-cache",
      "path"=> "/var/log/carbon-cache/current",
    }
  },
  {
    "file" => {
      "type"=> "rabbitmq",
      "path"=> "/var/log/rabbitmq/*log",
    }
  }
]

normal[:logstash][:agent][:outputs] = [
  {
    'rabbitmq' => {
      'exchange' => node[:bb_monitor][:logstash][:rabbitmq][:exchange],
      'exchange_type' => node[:bb_monitor][:logstash][:rabbitmq][:exchange_type],
      'host' => node[:bb_monitor][:logstash][:rabbitmq][:server],
      'password' => node[:bb_monitor][:logstash][:rabbitmq][:password],
      'user' => node[:bb_monitor][:logstash][:rabbitmq][:user]
    }
  }
]


# TODO: Add more patterns for other log types
normal[:logstash][:agent][:filters] = [
  {
    "grok"=> {
      "type" => "nginx_access",
      "match" => [
        "message", "%{IPORHOST:http_host} %{IPORHOST:clientip} \[%{HTTPDATE:timestamp}\] \"(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})\" %{NUMBER:response} (?:%{NUMBER:bytes}|-) %{QS:referrer} %{QS:agent} %{NUMBER:request_time:float} %{NUMBER:upstream_time:float}",
        "message", "%{IPORHOST:http_host} %{IPORHOST:clientip} \[%{HTTPDATE:timestamp}\] \"(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})\" %{NUMBER:response} (?:%{NUMBER:bytes}|-) %{QS:referrer} %{QS:agent} %{NUMBER:request_time:float}"
      ]
    },
    "date"=> {
      "type" => "nginx_access",
      "match" => [ "timestamp" , "dd/MMM/YYYY:HH:mm:ss Z" ]
    },
    "geoip"=> {
      "type" => "nginx_access",
      "source" => "clientip"
    }
  }
]
