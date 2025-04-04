#!/bin/bash

# Restart services for myRIMS
# This script stops and restarts the services defined in docker-compose.yml

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change to the script directory
cd "$SCRIPT_DIR"

echo "Stopping services..."
docker compose down

echo "Starting services..."
docker compose up -d

echo "Services restarted successfully!"
echo "Metabase UI: http://localhost:3000"
echo ""
echo "Note: Airbyte is not included in this docker-compose.yml file"
echo "Please use the official Airbyte Docker Compose file for setting up Airbyte"
echo "See README.md for instructions"
