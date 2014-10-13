source "https://supermarket.getchef.com"

cookbook 'elasticsearch', git: 'https://github.com/AlexanderZaytsev/elasticsearch.git'
cookbook 'kibana'
cookbook 'logstash', git: 'https://github.com/foxycoder/chef-logstash.git'
cookbook 'rabbitmq_cluster', path: './cookbooks/rabbitmq_cluster'

# Override opsworks to use community apache2
cookbook 'apache2'
