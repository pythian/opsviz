include_recipe "sensu::rabbitmq"
include_recipe "sensu::redis"

include_recipe "sensu::default"

include_recipe "bb_monitor::sensu_mutators"
include_recipe "bb_monitor::sensu_handlers"
include_recipe "bb_monitor::sensu_checks"
include_recipe "bb_monitor::sensu_extensions"


include_recipe "sensu::server_service"
include_recipe "sensu::api_service"

include_recipe "bb_monitor::sensu_client"
include_recipe "uchiwa"
