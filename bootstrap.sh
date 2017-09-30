gcloud container clusters create aok8s \
  --enable-autoupgrade \
  --enable-cloud-monitoring \
  --no-enable-cloud-logging \
  --enable-cloud-endpoints \
  --machine-type=n1-standard-1 \
  --num-nodes=2 \
  --scopes bigquery,storage-rw,monitoring,sql,sql-admin,default \
  --preemptible \
  --zone=europe-west1-b;
gcloud container clusters get-credentials aok8s;
helm init;
echo "Wait 30s for tiller to start";
sleep 30;
helm install --name ing --namespace kube-system --values traefik-values.yaml stable/traefik;
echo "NOW REMOVE THE EMBEDDED CERTS";
kubectl edit configmap ing-traefik -o yaml --namespace kube-system;
kubectl scale deployment/ing-traefik --replicas=0 --namespace kube-system; 
kubectl scale deployment/ing-traefik --replicas=1 --namespace kube-system;