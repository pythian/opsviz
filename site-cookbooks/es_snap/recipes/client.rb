node[:nfs_client][:packages].each do |p|
    package "#{p}" do
        action :install
    end
end

directory  "/opt/nfs" do
    owner  'root'
    mode   '0755'
    action :create
end

bash "Mount nfs" do
    user 'root'
    code <<-EOS
    nfs_server_ip="#{node[:nfs_server][:address]}"
    df -h | grep nfs
    if (( $? != 0 )); then
        /bin/mount -t nfs4 -o proto=tcp,port=2049 $nfs_server_ip:/opt/nfs /opt/nfs
    else
        echo "NFS already mounted, moving on"
    fi
    EOS
end
