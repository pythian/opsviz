# -*- mode: ruby -*-
# vi: set ft=ruby :

# read vm and chef configurations from JSON files
nodes_config = (JSON.parse(File.read("nodes.json")))["nodes"]
# chef_config  = (JSON.parse(File.read("chef.json")))["chef"]

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.5.0"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # 4-Feb-15 14:52:12 damonp v12.0.x throws checksum errors on some packages
  # config.omnibus.chef_version = "latest"
  # config.omnibus.chef_version = '11.16.4'
  # config.omnibus.chef_version = '11.8.2'
  config.omnibus.chef_version = '12.0.1'

  config.berkshelf.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.enabled = true

  nodes_config.each do |node|
    node_name   = node[0].to_s # name of node
    node_values = node[1] # content of node

    config.vm.define node_name do |config|
      # configures all forwarding ports in JSON array
      # ports = node_values["ports"]
      # ports.each do |port|
      #   config.vm.network :forwarded_port,
      #     host:  port[":host"],
      #     guest: port[":guest"],
      #     id:    port[":id"]
      # end

      #config.hostmanager.aliases = %w( node_name.dev )
      config.vm.hostname = node_values[":host"]
      config.vm.network :private_network, ip: node_values[":ip"]

      # syncs local repository of large third-party installer files (quicker than downloading each time)
      # config.vm.synced_folder "#{ENV["HOME"]}/chef_repo", "/vagrant"

      config.vm.provider :virtualbox do |vb|
        vb.name = node_values[":node"].to_s
        vb.memory = node_values[":memory"]
        vb.cpus = node_values[":cpus"]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
      end

      config.vm.provision "shell", inline: <<-SHELL
         sudo apt-get update -y
         sudo apt-get install git ruby-dev zlibc zlib1g-dev -y
         sudo apt-get autoremove -y
      SHELL

      config.vm.provision :chef_solo do |chef|
        chef.json = {
          # "nodejs" => {
          #   "version" => "0.10.7"
          # },
        }
        chef.json.merge!(JSON.parse(File.read("node.json")))
        # chef.json.merge!(JSON.parse(File.read("nodes.json")))
        # chef.json.merge!( { :instance => { :node => node_name, :host => node_values[":host"], :ip => node_values[":ip"] } } )
        opsworks_json = {
                          :name => node_values[":node"].to_s,
                          :opsworks => {
                            :instance => {
                              :node => node_name,
                              :hostname => node_values[":host"],
                              :layers => [ node_values[":roles"] ],
                              :ip => node_values[":ip"],
                              :private_ip => node_values[":ip"],
                              :region => "", # node[:aws_region]
                            },
                            :stack => {
                              :name => "Opsvis"
                            }
                          }
                        }

        chef.json.merge!( opsworks_json )
        chef.cookbooks_path = "site-cookbooks"
        chef.roles_path     = "roles"

        # todo: Create Roles
        if node_name =~ /^dashboard*/
          # chef.add_role "dashboard"

          chef.add_recipe "apache2"
          chef.add_recipe "nginx"
          chef.add_recipe "bb_monitor"
          chef.add_recipe "bb_monitor::nginx"

          chef.run_list = [
#            "recipe[bb_monitor::kibana]",
            "recipe[bb_monitor::grafana]",
            "recipe[bb_monitor::graphite]",
            "recipe[bb_monitor::flapjack]",

            "recipe[nginx]",
            "recipe[bb_monitor::nginx]",

            "recipe[bb_monitor::sensu_server]",
            #"recipe[bb_monitor::sensu_checks]",
            #"recipe[bb_monitor::sensu_custom_checks]",
            #"recipe[bb_monitor::sensu_stack_checks]",

            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"
          ]
        else if node_name =~ /^elastic*/
          # chef.add_role "elasticsearch"

          chef.add_recipe "bb_monitor"
          chef.add_recipe "bb_elasticsearch"

          chef.run_list = [
            "recipe[bb_elasticsearch]",

            # for logstash
            # "recipe[statsd]",
            # "recipe[bb_monitor::logstash_server]",

            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"

          ]
        else if node_name =~ /^logstash*/
          # chef.add_role "logstash"

          chef.add_recipe "bb_monitor"

          chef.run_list = [
            "recipe[statsd]",
            "recipe[bb_monitor::logstash_server]",

            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"
          ]
        else if node_name =~ /^rabbitmq*/
          chef.add_recipe "rabbitmq_cluster"
          chef.add_recipe "bb_monitor"

          chef.run_list = [
            "recipe[rabbitmq_cluster]",

            # for logstash
            # "recipe[statsd]",
            # "recipe[bb_monitor::logstash_server]",

            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"
          ]
        else
          chef.run_list = []
          end
          end
          end
        end
      end
    end
  end
end
