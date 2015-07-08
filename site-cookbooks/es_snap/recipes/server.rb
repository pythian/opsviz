node[:nfs][:packages].each do |p|
    package "#{p}" do
        action :install
    end
end

node[:nfs][:exports].each do |e|
directory  "#{e}" do
    owner  'root'
    mode   '0755'
    action :create
end

template "/etc/exports" do
    owner  'root'
    mode   00644
    source 'exports.erb'
    action :create
end

template "/etc/default/nfs-kernel-server" do
    owner  'root'
    mode   '00644'
    source 'nfs-kernel-server.erb'
    action :create
    notifies :restart, "service[nfs-kernel-server]"
end

service "nfs-kernel-server" do
    supports :restart => true, :reload => true, :start => true, :stop => true
    action :restart
end
