#!/bin/bash

# Build and push Docker images for myRIMS
# Usage: ./build-and-push.sh [registry-url]

# Set the registry URL
REGISTRY_URL=${1:-"localhost:5000"}

# Generate SQL files for the CERIF data model
echo "Generating SQL files for the CERIF data model..."
cd database/scripts
./generate-sql.sh
cd ../..

# Build and push the database image
echo "Building and pushing the database image..."
docker build -t ${REGISTRY_URL}/myRIMS/database:latest ./database
docker push ${REGISTRY_URL}/myRIMS/database:latest

# Build and push the Metabase image
echo "Building and pushing the Metabase image..."
docker build -t ${REGISTRY_URL}/myRIMS/metabase:latest ./metabase
docker push ${REGISTRY_URL}/myRIMS/metabase:latest

# Build and push the Airbyte image
echo "Building and pushing the Airbyte image..."
docker build -t ${REGISTRY_URL}/myRIMS/airbyte:latest ./airbyte
docker push ${REGISTRY_URL}/myRIMS/airbyte:latest

echo "All images built and pushed successfully!"
