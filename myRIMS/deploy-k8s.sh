#!/bin/bash

# Deploy myRIMS to Kubernetes
# Usage: ./deploy-k8s.sh [registry-url] [domain]

# Set the registry URL and domain
REGISTRY_URL=${1:-"localhost:5000"}
DOMAIN=${2:-"example.com"}

# Replace placeholders in Kubernetes YAML files
echo "Replacing placeholders in Kubernetes YAML files..."
sed -i "s|\${REGISTRY_URL}|${REGISTRY_URL}|g" k8s/*.yaml
sed -i "s|\${DOMAIN}|${DOMAIN}|g" k8s/*.yaml

# Apply Kubernetes YAML files
echo "Applying Kubernetes YAML files..."
kubectl apply -f k8s/database.yaml
kubectl apply -f k8s/metabase.yaml
kubectl apply -f k8s/airbyte.yaml

# Create namespace for monitoring if it doesn't exist
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Deploy Prometheus and Grafana for monitoring
echo "Deploying monitoring stack..."
kubectl apply -f k8s/monitoring/prometheus.yaml
kubectl apply -f k8s/monitoring/grafana.yaml

# Create namespace for backup if it doesn't exist
kubectl create namespace backup --dry-run=client -o yaml | kubectl apply -f -

# Deploy Velero for backup and disaster recovery
echo "Deploying backup solution..."
kubectl apply -f k8s/backup/velero.yaml

echo "myRIMS components deployed successfully to Kubernetes!"
echo "Metabase UI: https://metabase.${DOMAIN}"
echo "Airbyte UI: https://airbyte.${DOMAIN}"
echo "Grafana UI: https://grafana.${DOMAIN}"
echo ""
echo "Next steps:"
echo "1. Configure Airbyte connectors for your data sources"
echo "2. Set up Grafana dashboards for monitoring"
echo "3. Configure backup schedules in Velero"
