KUBECTL="/Users/alt/Pythian/kubernetes/_output/local/go/bin/kubectl --api-version=v1beta3"

$KUBECTL delete rc elasticsearch-client
$KUBECTL delete rc elasticsearch-data
$KUBECTL delete rc elasticsearch-master
$KUBECTL delete rc redis
$KUBECTL delete rc rabbitmq-controller
$KUBECTL delete rc dashboard-nginx
$KUBECTL delete service rabbitmq-controller
$KUBECTL delete service dashboard-service
$KUBECTL delete service elasticsearch-service
$KUBECTL delete service rabbitmq-service