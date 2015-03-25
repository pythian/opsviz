name "Opsworks Default"
description "Opsworks Default Node Role.  Installs basic Opsworks recipes and dependencies."
run_list(
  "recipe[opsworks_initial_setup]",
  "recipe[dependencies]",
  "recipe[opsworks_ganglia::client]",
  "recipe[deploy::default]",
  "recipe[opsworks_ganglia::configure-client]"
)
