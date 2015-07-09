name             "rabbitmq_cluster"
version          '0.1.0'

%w{ubuntu debian linuxmint redhat centos scientific amazon fedora oracle smartos suse}.each do |os|
      supports os
end

%w{ rabbitmq }.each do |ckbk|
      depends ckbk, "= 3.3.0"
end

depends 'bb_monitor'
