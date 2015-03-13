# Installing the Clients

## With Chef

## Without Chef (using chef-zero)
This section assumes that you want to install the client(s) on a remote server from your laptop and that you’re not already managing that server with any version of Chef.

1. Download and install [Chef-DK](https://downloads.chef.io/chef-dk/)
1. Add [knife-zero](https://github.com/higanworks/knife-zero)

    $ chef gem install knife-zero

1. Add a Berksfile to your directory containing these two lines:

    source 'https://supermarket.chef.io'  
    cookbook 'bb_external', git: 'https://github.com/pythian/opsviz.git', rel: 'site-cookbooks/bb_external'  
    cookbook 'logstash', git: 'https://github.com/foxycoder/chef-logstash.git'

1. Use Berkshelf to vendor all the cookbooks you need.

    $ berks vendor cookbooks

1. Update the custom json
1. Use knife-zero to bootstrap your remote server

    $ knife zero bootstrap x.x.x.x -r bb_external::sensu_client --no-host-key-verify

1. __Profit!__


## Manually

## Using ansible
