# -*- mode: ruby -*-
# vi: set ft=ruby :

# read vm and chef configurations from JSON files
nodes_config = (JSON.parse(File.read("nodes.json")))["nodes"]
<<<<<<< HEAD
=======
#chef_config  = (JSON.parse(File.read("chef.json")))["chef"]
>>>>>>> Start Vagrantfile setup

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.5.0"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
<<<<<<< HEAD

  config.omnibus.chef_version = "latest"
  # config.omnibus.chef_version = '12.0.1'
  # config.omnibus.chef_version = '11.16.4'
  # config.omnibus.chef_version = '11.10.0'

  config.berkshelf.enabled = true
=======
  config.berkshelf.enabled = true
  config.omnibus.chef_version = "latest"
>>>>>>> Start Vagrantfile setup
  config.hostmanager.manage_host = true
  config.hostmanager.enabled = true

  nodes_config.each do |node|
<<<<<<< HEAD
    node_name   = node[0].to_s # name of node
    node_values = node[1] # content of node
    aliases = Array.new()

    config.vm.define node_name do |config|
      aliases.push(node_values[":lb"])

      config.hostmanager.aliases = aliases
      config.vm.hostname = node_values[":host"]
      config.vm.network :private_network, ip: node_values[":ip"]

      config.vm.provider :virtualbox do |vb|
        vb.name = node_values[":node"].to_s
=======
    node_name   = node[0] # name of node
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

      #node[:opsworks][:instance][:hostname] = node_values[":host"]

      config.hostmanager.aliases = %w( "#{node_values[:node]}.opsvis.dev" )
      config.vm.hostname = node_values[":host"]
      config.vm.network :private_network, ip: node_values[":ip"]

      # syncs local repository of large third-party installer files (quicker than downloading each time)
      # config.vm.synced_folder "#{ENV["HOME"]}/chef_repo", "/vagrant"

      config.vm.provider :virtualbox do |vb|
        vb.name = node_values[":node"]
>>>>>>> Start Vagrantfile setup
        vb.memory = node_values[":memory"]
        vb.cpus = node_values[":cpus"]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
      end

<<<<<<< HEAD
=======
      ## chef configuration section
      # config.vm.provision :chef_client do |chef|
      #   chef.environment = chef_config[":environment"]
      #   chef.provisioning_path = chef_config[":provisioning_path"]
      #   chef.chef_server_url = chef_config[":chef_server_url"]
      #   chef.validation_key_path = chef_config[":validation_key_path"]
      #   chef.node_name = node_values[":node"]
      #   chef.validation_client_name = chef_config[":validation_client_name"]
      #   chef.client_key_path = chef_config[":client_key_path"]
      # end

>>>>>>> Start Vagrantfile setup
      config.vm.provision "shell", inline: <<-SHELL
         sudo apt-get update -y
         sudo apt-get install git ruby-dev zlibc zlib1g-dev -y
         sudo apt-get autoremove -y
      SHELL

      config.vm.provision :chef_solo do |chef|
        chef.json = {
<<<<<<< HEAD
          :name => node_values[":node"].to_s,
          :fqdn => node_values[":host"],
          :provider => "vagrant"
        }

        chef.json.merge!(JSON.parse(File.read("node.json")))

        opsworks_json = {
                          :opsworks => {
                            :instance => {
                              :node => node_name,
                              :hostname => node_name,
                              :layers => node_values[":roles"],
                              :ip => node_values[":ip"],
                              :private_ip => node_values[":ip"],
                              :region => "local",
                              :aws_instance_id => node_name,
                              :availability_zone => "vagrant"
                            },
                            :layers => {
                              :dashboard   =>  {
                                :instances  =>  [ "dashboard-1" ]
                              },
                              :elasticsearch   =>  {
                                :instances  =>  [ "elastic-1" ]
                              },
                              :logstash   =>  {
                                :instances  =>  [ "logstash-1" ]
                              },
                              :rabbitmq   =>  {
                                :instances  =>  [ "rabbitmq-1" ]
                              }
                            },
                            :stack => {
                              :name => "Opsvis"
                            }
                          }
                        }

        chef.json.merge!( opsworks_json )
        chef.cookbooks_path = ["site-cookbooks", "ops/opsworks-cookbooks"]
        chef.roles_path     = ["roles", "ops/opsworks-roles" ]
        # chef.data_bags_path = ["data_bags" ]

        if node_name =~ /^dashboard*/
          # chef.add_role "opworks_default"
          chef.add_role "dashboard"
          chef.add_role "opsvis_client"

        else if node_name =~ /^elastic*/
          # chef.add_role "opworks_default"
          chef.add_role "elasticsearch"
          chef.add_role "opsvis_client"

        else if node_name =~ /^logstash*/
          # chef.add_role "opworks_default"
          chef.add_role "logstash"
          chef.add_role "opsvis_client"

        else if node_name =~ /^rabbitmq*/
          # chef.add_role "opworks_default"
          chef.add_role "rabbitmq"
          chef.add_role "opsvis_client"

=======
          # "nodejs" => {
          #   "version" => "0.10.7"
          # },
        }
        chef.json.merge!(JSON.parse(File.read("node.json")))
        # chef.json.merge!(JSON.parse(File.read("nodes.json")))

        chef.cookbooks_path = "site-cookbooks"
        chef.roles_path     = "roles"

        #chef.add_recipe "bb_external"

        # if node_values[:tags].include?("dashboard")
        if node_name =~ /^dashboard*/
          #chef.add_role "dashboard"

          #chef.add_recipe "apache2"
          chef.add_recipe "nginx"
          chef.add_recipe "bb_monitor"
          chef.add_recipe "bb_monitor::nginx"

          chef.run_list = [
#            "recipe[bb_monitor::kibana]",
            "recipe[bb_monitor::grafana]",
            "recipe[bb_monitor::graphite]",
            "recipe[bb_monitor::sensu_server]",
            "recipe[nginx]",
            "recipe[bb_monitor::nginx]",

            #"recipe[bb_monitor::logstash_server]",
            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"
          ]
        else if node_name =~ /^elastic*/
          chef.add_recipe "bb_monitor"
          chef.add_recipe "bb_elasticsearch"

          chef.run_list = [
            "recipe[bb_elasticsearch]",
            "recipe[statsd]",
            "recipe[bb_monitor::logstash_server]",
            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"

          ]
        else if node_name =~ /^logstash*/
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
            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"
          ]
>>>>>>> Start Vagrantfile setup
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
