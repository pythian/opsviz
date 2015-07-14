# Fix for encoding bug
Encoding.default_external = "utf-8"

source "https://supermarket.getchef.com"

# Community Cookbooks
cookbook 'elasticsearch', '~> 0.3.13'
cookbook 'grafana', '~> 2.0.0'
cookbook 'graphite', '~> 1.0.2', git: 'https://github.com/hw-cookbooks/graphite.git'
cookbook 'kibana', '~> 0.1.8'
cookbook 'logstash', '~> 0.1.0', git: 'https://github.com/lesaux/chef-logstash.git'
cookbook 'route53', '~> 0.4.0', git: 'https://github.com/josacar/route53.git'
cookbook 'sensu', '~> 2.6.0'
cookbook 'statsd', '~> 1.1.10', git: 'https://github.com/hectcastro/chef-statsd.git'

# Our Cookbooks
cookbook 'rabbitmq_cluster', '~> 0.1.0', path: './site-cookbooks/rabbitmq_cluster'
cookbook 'bb_elasticsearch', '~> 0.1.0', path: './site-cookbooks/bb_elasticsearch'
cookbook 'bb_monitor', '~> 0.1.0', path: './site-cookbooks/bb_monitor'
cookbook 'bb_external', '~> 0.1.0', path: './site-cookbooks/bb_external'

# Override opsworks to use community apache2
cookbook 'apache2', '~> 2.0.0', path: './apache2'
cookbook 'nginx', '~> 2.7.4', path: './nginx'
