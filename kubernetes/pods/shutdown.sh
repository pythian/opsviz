KUBECTL="/Users/alt/Pythian/kubernetes/_output/local/go/bin/kubectl --api-version=v1beta3"

$KUBECTL delete rc elasticsearch-client
$KUBECTL delete rc elasticsearch-data
$KUBECTL delete rc elasticsearch-master
$KUBECTL delete rc sensu-server
$KUBECTL delete rc sensu-api
$KUBECTL delete rc redis
$KUBECTL delete rc dashboard-nginx
$KUBECTL delete rc rabbitmq-controller
$KUBECTL delete rc grafana-controller
$KUBECTL delete service dashboard
$KUBECTL delete service graphite
$KUBECTL delete service elasticsearch-service
$KUBECTL delete service rabbitmq
$KUBECTL delete service sensu
