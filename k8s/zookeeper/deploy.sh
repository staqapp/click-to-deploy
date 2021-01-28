export CLUSTER=nifi-zookeeper-1
export PROJECT=nifi-staq-services
export ZONE=us-east1-b
export APP_INSTANCE_NAME=zookeeper
export NAMESPACE=default
export DEFAULT_STORAGE_CLASS="standard"
export PERSISTENT_DISK_SIZE="10Gi"
export METRICS_EXPORTER_ENABLED=false
export TAG="3.6"
export IMAGE_REGISTRY="marketplace.gcr.io/google"
export IMAGE_ZOOKEEPER="${IMAGE_REGISTRY}/zookeeper"
export IMAGE_ZOOKEEPER_EXPORTER="${IMAGE_REGISTRY}/zookeeper/exporter"
export IMAGE_METRICS_EXPORTER="${IMAGE_REGISTRY}/zookeeper/prometheus-to-sd:${TAG}"
export ZOOKEEPER_REPLICAS=3
export ZOOKEEPER_MEMORY_REQUEST=1250Mi
export ZOOKEEPER_CPU_REQUEST=300m
export ZOOKEEPER_TICKTIME=2000
export ZOOKEEPER_CLIENT_MAX_CNXNX=60
export ZOOKEEPER_AUTO_PURGE_SNAP_RETAIN_COUNT=3
export ZOOKEEPER_PURGE_INTERVAL=24
export ZOOKEEPER_HEAP_SIZE=1000M

/usr/local/opt/helm@2/bin/helm template chart/zookeeper \
  --name "${APP_INSTANCE_NAME}" \
  --namespace "${NAMESPACE}" \
  --set zookeeper.image.name="${IMAGE_ZOOKEEPER}" \
  --set zookeeper.image.tag="${TAG}" \
  --set exporter.image="${IMAGE_ZOOKEEPER_EXPORTER}" \
  --set exporter.tag="${TAG}" \
  --set metrics.image="${IMAGE_METRICS_EXPORTER}" \
  --set metrics.exporter.enabled="${METRICS_EXPORTER_ENABLED}" \
  --set zookeeper.zkReplicas="${ZOOKEEPER_REPLICAS}" \
  --set zookeeper.zkTicktime="${ZOOKEEPER_TICKTIME}" \
  --set zookeeper.zkMaxClientCnxns="${ZOOKEEPER_CLIENT_MAX_CNXNX}" \
  --set zookeeper.zkAutopurgeSnapRetainCount="${ZOOKEEPER_AUTO_PURGE_SNAP_RETAIN_COUNT}" \
  --set zookeeper.zkPurgeInterval="${ZOOKEEPER_PURGE_INTERVAL}" \
  --set zookeeper.memoryRequest="${ZOOKEEPER_MEMORY_REQUEST}" \
  --set zookeeper.cpuRequest="${ZOOKEEPER_CPU_REQUEST}" \
  --set zookeeper.zkHeapSize="${ZOOKEEPER_HEAP_SIZE}" \
  --set zookeeper.persistence.size="${PERSISTENT_DISK_SIZE}" \
  --set zookeeper.persistence.storageClass="${DEFAULT_STORAGE_CLASS}" \
  > "${APP_INSTANCE_NAME}_manifest.yaml"

gcloud container clusters get-credentials "${CLUSTER}" --zone "${ZONE}" --project "${PROJECT}"
kubectl apply -f "${APP_INSTANCE_NAME}_manifest.yaml" --namespace "${NAMESPACE}"