# GKE only supports v1beta3 today
KUBECTL="/Users/alt/Pythian/kubernetes/_output/local/go/bin/kubectl --api-version=v1beta3"

for each in rabbitmq-service.yaml dashboard-service.yaml elasticsearch-service.yaml grafana-service.yaml graphite-service.yaml sensu-service.yaml; do
    echo "Starting $each"
    $KUBECTL create -f $each
done

for each in rabbitmq-controller.yaml; do
    echo "Starting $each"
    $KUBECTL create -f $each
done

for each in redis-master.yaml elasticsearch-client.yaml elasticsearch-master.yaml elasticsearch-data.yaml ; do
    echo "Starting $each"
    $KUBECTL create -f $each
done

for each in grafana-controller.yaml graphite-controller.yaml; do
    echo "Starting $each"
    $KUBECTL create -f $each
done

for each in sensu-server.yaml sensu-api.yaml; do
    echo "Starting $each"
    $KUBECTL create -f $each
done

for each in dashboard-nginx.yaml; do
    echo "Starting $each"
    $KUBECTL create -f $each
done

# Open up the firewall(s)
gcloud compute firewall-rules create allow-rabbitmq --allow=tcp:5672
gcloud compute firewall-rules create allow-dashboard --allow=tcp:80
