
template "/home/vagrant/es_backup.sh" do
    owner  'root'
    mode   00755
    source 'es_backup.sh.erb'
    action :create
end

cron "ES_snapshot_cronjob" do
    home "/home/vagrant/"
    shell "/bin/bash"
    minute "44"
    hour '*'
    day '*'
    month '*'
    weekday '*'
    command "/home/vagrant/es_backup.sh  2>&1 | /usr/bin/logger -t es_snapshot"
    action :create
end
