# -*- mode: ruby -*-
# vi: set ft=ruby :

# read vm and chef configurations from JSON files
nodes_config = (JSON.parse(File.read("nodes.json")))["nodes"]
# chef_config  = (JSON.parse(File.read("chef.json")))["chef"]

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.5.0"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.omnibus.chef_version = "latest"
  # config.omnibus.chef_version = '12.0.1'
  # config.omnibus.chef_version = '11.16.4'
  # config.omnibus.chef_version = '11.10.0'

  config.berkshelf.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.enabled = true

  nodes_config.each do |node|
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
          :name => node_values[":node"].to_s,
          :provider => "vagrant"
        }
        chef.json.merge!(JSON.parse(File.read("node.json")))
        opsworks_json = {
                          :opsworks => {
                            :instance => {
                              :node => node_name,
                              #:hostname => node_values[":host"],
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

        # todo: Create Roles
        if node_name =~ /^dashboard*/
          # chef.add_role "dashboard"

          chef.add_recipe "apache2"
          chef.add_recipe "nginx"
          chef.add_recipe "bb_monitor"
          #chef.add_recipe "bb_monitor::nginx"

          chef.run_list = [
            #"recipe[opsworks_initial_setup]",
            #"recipe[dependencies]",
            #"recipe[opsworks_ganglia::client]",
            #"recipe[deploy::default]",
            #"recipe[opsworks_ganglia::configure-client]",

            "recipe[bb_monitor::kibana]",
            "recipe[bb_monitor::grafana]",
            "recipe[bb_monitor::graphite]",
            "recipe[bb_monitor::flapjack]",

            "recipe[bb_monitor::doorman]",
            "recipe[bb_monitor::sensu_server]",
            "recipe[bb_monitor::sensu_checks]",
            "recipe[bb_monitor::sensu_custom_checks]",
            "recipe[bb_monitor::sensu_stack_checks]",

            "recipe[nginx]",
            "recipe[bb_monitor::nginx]",

            "recipe[bb_monitor::logstash_agent]",
            "recipe[bb_monitor::sensu_client]"
          ]
        else if node_name =~ /^elastic*/
          # chef.add_role "elasticsearch"

          chef.add_recipe "bb_monitor"
          chef.add_recipe "bb_elasticsearch"

          chef.run_list = [
            "recipe[bb_elasticsearch]",

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
          # chef.add_role "rabbitmq"
          chef.add_recipe "rabbitmq_cluster"
          chef.add_recipe "bb_monitor"

          chef.run_list = [
            "recipe[rabbitmq_cluster]",

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
