default[:nfs_server][:packages] = %w(nfs-common nfs-kernel-server portmap rpcbind)
default[:nfs_server][:address] = '10.10.10.10'
default[:nfs_client][:packages] = [ 'nfs-common' ]
default[:nfs][:exports] = [ '/opt/nfs', ]
