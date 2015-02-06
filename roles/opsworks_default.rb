name "Opsworks Default"
description "Opsworks Default Node Role"
run_list(
  "recipe[opsworks_initial_setup]",
  "recipe[dependencies]",
  "recipe[opsworks_ganglia::client]",
  "recipe[deploy::default]",
  "recipe[opsworks_ganglia::configure-client]"
)
