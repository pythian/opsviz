FROM elasticsearch:1.6

MAINTAINER lovelltroy@pythian.com

# Install the aws-cloud plugin for backups to s3
RUN /usr/share/elasticsearch/bin/plugin install elasticsearch/elasticsearch-cloud-aws/2.6.0

# Override elasticsearch.yml config
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml
