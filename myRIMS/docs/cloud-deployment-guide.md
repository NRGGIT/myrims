# myRIMS Cloud Deployment Guide

This guide provides detailed instructions for deploying myRIMS to a cloud environment using Docker Compose. This approach is suitable for cloud platforms that support Docker Compose deployments with environment variables, volumes, and port mapping.

## Prerequisites

- Docker and Docker Compose installed on your local machine
- Access to a container registry (e.g., Docker Hub, Google Container Registry, AWS ECR)
- Access to a cloud platform that supports Docker Compose deployments
- Git installed on your local machine

## Deployment Steps

### 1. Prepare for Deployment

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/myRIMS.git
   cd myRIMS
   ```

2. Create an `.env` file with the following content (or copy from `.env.template`):
   ```
   # Registry URL for Docker images
   REGISTRY_URL=your-registry-url
   
   # Ports for services (these will be assigned by your cloud platform)
   POSTGRES_PORT=5432
   METABASE_PORT=3000
   AIRBYTE_DB_PORT=5433
   AIRBYTE_SERVER_PORT=8001
   AIRBYTE_WEBAPP_PORT=80
   ```

   Replace `your-registry-url` with your container registry URL (e.g., `docker.io/yourusername` for Docker Hub).

3. Understand the Dockerfiles:
   - `db.dockerfile`: A multi-stage build that generates SQL files for the CERIF data model and creates a PostgreSQL database
   - `metabase.dockerfile`: Extends the official Metabase image with custom configurations
   - `airbyte.dockerfile`: Extends the official Airbyte server image with custom configurations

### 2. Configure Environment Variables

1. Review and modify the `.env` file to match your cloud platform's requirements:
   ```
   # Registry URL for Docker images
   REGISTRY_URL=your-registry-url
   
   # Database hosts (use the full address for your cloud environment)
   DB_HOST=svc-postgres.app-4fe8f1a1.svc.cluster.local
   AIRBYTE_DB_HOST=svc-airbyte-db.app-4fe8f1a1.svc.cluster.local
   
   # Ports for services (these will be assigned by your cloud platform)
   POSTGRES_PORT=5432
   METABASE_PORT=3000
   AIRBYTE_DB_PORT=5433
   AIRBYTE_SERVER_PORT=8001
   AIRBYTE_WEBAPP_PORT=80
   ```

   Adjust the following values as needed for your cloud platform:
   - `REGISTRY_URL`: Your container registry URL
   - `DB_HOST`: The address of your PostgreSQL service in the cloud environment
   - `AIRBYTE_DB_HOST`: The address of your Airbyte database service in the cloud environment
   - Port values: Some cloud platforms may assign these ports dynamically

2. If your cloud platform requires additional environment variables (e.g., for authentication, networking), add them to the `.env` file.

### 3. Deploy to the Cloud Platform

1. Upload the following files to your cloud platform:
   - `cloud-docker-compose.yml`
   - `.env`
   - `db.dockerfile`
   - `metabase.dockerfile`
   - `airbyte.dockerfile`
   - The entire `database` directory (containing scripts and init subdirectories)

2. Use your cloud platform's interface to deploy the application:
   - Specify the `cloud-docker-compose.yml` file as the configuration file
   - Ensure the `.env` file is in the same directory or properly referenced
   - Configure any platform-specific settings (e.g., networking, storage)
   - The cloud-docker-compose.yml file is configured to build the images using the Dockerfiles

3. Ensure all required ports are exposed as HTTPS if needed:
   - Metabase UI: Port 3000
   - Airbyte UI: Port 80
   - Airbyte Server: Port 8001
   - PostgreSQL: Port 5432
   - Airbyte DB: Port 5433

### 4. Post-Deployment Configuration

After successful deployment, you need to configure the services:

#### Database

The PostgreSQL database is automatically initialized with the CERIF data model, roles, and sample data. No additional configuration is required.

#### Metabase

1. Access the Metabase UI at the URL provided by your cloud platform (e.g., `https://metabase.your-domain.com`).
2. Complete the first-time setup:
   - Create an admin account
   - Connect to the PostgreSQL database using the following credentials:
     - Host: `postgres`
     - Port: `5432`
     - Database: `rims_db`
     - Username: `rims_admin`
     - Password: `rims_password`
3. Create dashboards and visualizations for different roles:
   - Principal Investigators
   - Researchers
   - Research Administrators
   - Financial Officers
   - Grant Officers
   - Institutional Executives
   - Library Managers
   - System Administrators
   - External Collaborators

#### Airbyte

1. Access the Airbyte UI at the URL provided by your cloud platform (e.g., `https://airbyte.your-domain.com`).
2. Configure sources for external data:
   - Scopus
   - OpenAlex
   - ORCID
   - CrossRef
   - Other relevant data sources
3. Set up destinations to the PostgreSQL database:
   - Host: `postgres`
   - Port: `5432`
   - Database: `rims_db`
   - Username: `rims_admin`
   - Password: `rims_password`
4. Create and schedule synchronization jobs to regularly update the data.

### 5. Security Considerations

1. **Credentials**: Change the default passwords in the `.env` file and `cloud-docker-compose.yml` file before deploying to production.
2. **HTTPS**: Ensure all services are accessible only via HTTPS.
3. **Network Security**: Configure network security rules to restrict access to the services.
4. **Authentication**: Set up authentication for all services.
5. **Backup**: Configure regular backups of the PostgreSQL database.

## Troubleshooting

### Common Issues

1. **Images not found**: Ensure the registry URL in the `.env` file is correct and the images have been pushed to the registry.
2. **Services not starting**: Check the logs for error messages. Common issues include:
   - Insufficient resources (memory, CPU)
   - Port conflicts
   - Volume mount issues
3. **Database build errors**: If you encounter errors during the database build process, check that:
   - The directory structure is correct (the `database` directory contains both `scripts` and `init` subdirectories)
   - The `db.dockerfile` is correctly configured to copy and run the scripts
   - The paths in the COPY commands match the actual directory structure
4. **"su: unrecognized option: j" error**: This error occurs in the PostgreSQL container when it tries to execute initialization scripts. We've addressed this by:
   - Adding `ENV POSTGRES_INITDB_ARGS="--no-su-prefix"` to the db.dockerfile
   - Using non-root users in the Metabase and Airbyte Dockerfiles
   - If you still encounter this error, you may need to modify the PostgreSQL entrypoint script or use a different PostgreSQL image
5. **Metabase logging errors**: If you encounter errors related to Metabase log files (e.g., "no such file or directory" for log files), we've addressed this by:
   - Creating necessary log directories with appropriate permissions in the Metabase Dockerfile
   - Setting explicit logging configuration via environment variables
   - If you still encounter logging issues, you may need to mount a persistent volume for logs or adjust the permissions further
6. **Database connection issues**: Ensure the PostgreSQL service is running and the credentials are correct. In cloud environments, make sure to set the correct database host address in the `.env` file.
7. **Metabase not connecting to the database**: Ensure the PostgreSQL service is running and the credentials in the Metabase configuration are correct. In cloud environments, set the `DB_HOST` environment variable to the correct address (e.g., `svc-postgres.app-4fe8f1a1.svc.cluster.local`).
8. **Airbyte not connecting to the database**: Ensure the PostgreSQL service is running and the credentials in the Airbyte configuration are correct. In cloud environments, set the `AIRBYTE_DB_HOST` environment variable to the correct address.

### Logs

To view the logs for a service:

```bash
docker logs [container-name]
```

Replace `[container-name]` with the name of the container (e.g., `myRIMS_postgres_1`, `myRIMS_metabase_1`).

## Maintenance

### Updating the Application

To update the application:

1. Pull the latest changes from the repository:
   ```bash
   git pull
   ```

2. Run the deployment script to build and push the updated Docker images:
   ```bash
   ./deploy-cloud.sh [registry-url]
   ```

3. Redeploy the application on your cloud platform.

### Backup and Restore

To backup the PostgreSQL database:

```bash
docker exec -t [postgres-container-name] pg_dump -U rims_admin rims_db > backup.sql
```

To restore the PostgreSQL database:

```bash
cat backup.sql | docker exec -i [postgres-container-name] psql -U rims_admin -d rims_db
```

Replace `[postgres-container-name]` with the name of the PostgreSQL container.

## Support

If you encounter any issues or have questions, please open an issue on the GitHub repository or contact the maintainers.
