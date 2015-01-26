# Fix for encoding bug
Encoding.default_external = "utf-8"

source "https://supermarket.getchef.com"

# Community Cookbooks
cookbook 'elasticsearch'
cookbook 'grafana'
cookbook 'graphite'
cookbook 'kibana'
cookbook 'logstash', git: 'https://github.com/foxycoder/chef-logstash.git'
cookbook 'sensu'
cookbook 'statsd', git: 'https://github.com/hectcastro/chef-statsd.git'

# Our Cookbooks
cookbook 'rabbitmq_cluster', path: './site-cookbooks/rabbitmq_cluster'
cookbook 'bb_elasticsearch', path: './site-cookbooks/bb_elasticsearch'
cookbook 'bb_monitor', path: './site-cookbooks/bb_monitor'
cookbook 'bb_external', path: './site-cookbooks/bb_external'
cookbook 'iMatchative', git: 'git@bitbucket.org:/imatchative/imatchative_deploy.git', rel: 'site-cookbooks/imatchative/', branch: 'master'

# Override opsworks to use community apache2
cookbook 'apache2', path: './apache2'
cookbook 'nginx', path: './nginx'
