cron "logstash" do
  user "root"
  command "/usr/bin/perl -ne 'system(\"/sbin/initctl restart logstash\") if (/RabbitMQ connection error/ and eof )' /var/log/logstash/logstash.log  >> /root/logstash.errors.log 2>&1"
end
