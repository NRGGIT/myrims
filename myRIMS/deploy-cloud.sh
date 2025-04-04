#!/bin/bash

# Deploy myRIMS to cloud
# Usage: ./deploy-cloud.sh [registry-url]

# Set the registry URL
REGISTRY_URL=${1:-"localhost:5000"}

# Generate SQL files for the CERIF data model
echo "Generating SQL files for the CERIF data model..."
cd database/scripts
./generate-sql.sh
cd ../..

# Ensure the SQL files are not ignored by git
echo "Ensuring SQL files are not ignored by git..."
if grep -q "^database/init/\*.sql" .gitignore; then
  echo "Updating .gitignore to not ignore SQL files..."
  sed -i 's/^database\/init\/\*.sql/# database\/init\/\*.sql/' .gitignore
fi

# Add the SQL files to git if they're not already tracked
echo "Adding SQL files to git..."
git add database/init/*.sql
git commit -m "Add SQL files for database initialization" || true

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

# Generate .env file for cloud deployment
echo "Generating .env file for cloud deployment..."
cat > .env << EOF
# Registry URL for Docker images
REGISTRY_URL=${REGISTRY_URL}

# Ports for services (these will be assigned by your cloud platform)
POSTGRES_PORT=5432
METABASE_PORT=3000
AIRBYTE_DB_PORT=5433
AIRBYTE_SERVER_PORT=8001
AIRBYTE_WEBAPP_PORT=80
EOF

echo "All images built and pushed successfully!"
echo ""
echo "Next steps for cloud deployment:"
echo "1. Upload the following files to your cloud platform:"
echo "   - cloud-docker-compose.yml"
echo "   - .env (adjust port values as needed for your cloud platform)"
echo ""
echo "2. Deploy the application using your cloud platform's interface"
echo "   - Use the cloud-docker-compose.yml file for configuration"
echo "   - Ensure all required ports are exposed as HTTPS if needed"
echo ""
echo "3. After deployment, configure the following:"
echo "   - Set up Metabase dashboards for different user roles"
echo "   - Configure Airbyte connectors for your data sources"
echo "   - Set up scheduled data synchronization jobs"
echo ""
echo "4. Access your application at the URLs provided by your cloud platform"
