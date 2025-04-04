# myRIMS - Research Information Management System

A Research Information Management System (RIMS) based on the CERIF (Common European Research Information Format) data model. This system provides a comprehensive solution for managing research information, including researchers, projects, publications, funding, and more.

## Deployment Recommendation

**Cloud Deployment Recommended**: For the best experience, especially for users with Apple M1/M2 Macs or other systems that may encounter platform compatibility issues, we recommend deploying this system to a cloud environment. The system is designed to work seamlessly in cloud environments and includes Kubernetes configuration files for easy deployment.

If you prefer local development, you can still use the Docker Compose setup, but be aware that you may encounter platform compatibility issues with some components, particularly Metabase.

## Features

- **CERIF-compliant Database**: Implements the CERIF data model for research information management
- **Role-based Access Control**: Different roles have different read-write permissions
- **User Interface**: Metabase-based interface for data exploration and management
- **Integration Interface**: Airbyte-based integration for connecting to external data sources

## System Architecture

The system consists of the following components:

1. **PostgreSQL Database**: Stores all research information according to the CERIF data model
2. **Metabase**: Provides a user interface for data exploration and management
3. **Airbyte**: Enables integration with external data sources

## Roles

The system supports the following roles:

| Role | Key objective | Other objectives | RIMS Key Scenario |
|---|---|---|---|
| Principal Investigators (PI) | Define research goals and manage research process | Manage and coordinate research projects; oversee teams; secure funding; ensure timely and impactful research outcomes; maintain compliance and reporting obligations. | A PI logs into the RIMS to manage their research portfolio, from project inception to publication. |
| Researchers | Do research and publish results | Conduct research effectively; publish findings in journals and conferences; collaborate efficiently; enhance visibility within the academic community; | A researcher logs into the RIM to update their profile, link new project outputs, and search for international collaboration or funding opportunities. |
| Research Administrators | Maximize institutional research impact and reputation. | Support all administrative aspects of research management; facilitate collaboration; improve reporting efficiency; maximize institutional research impact and reputation. | An administrator uses the system to manage and certify research activity across the institution, ensuring compliance, timely reporting, and efficient workflow management. |
| Financial Officers | Ensure accurate financial tracking and reporting | Ensure accurate financial management and accounting of research-related funds; monitor budgets and expenditures; manage audits; provide reliable financial analytics and reporting to stakeholders. | A financial officer logs into the RIM to monitor research budgets, track expenditures, and generate financial reports to support audits and budget reviews. |
| Grant Officers | Maximize grants rate of applications/awards/succeed projects | Support researchers in identifying funding opportunities; streamline proposal submission processes; manage award documentation and compliance; oversee reporting obligations and ensure funder requirements are met. | A grant officer leverages the RIM to identify funding opportunities, manage proposal submissions, and ensure compliance with award conditions. |
| Institutional Executives | Strengthen the institution's competitive position through informed decisions | Enhance strategic oversight of institutional research activities; monitor institutional research performance; inform strategic decisions; optimize resource allocation; strengthen institution's academic reputation and competitive standing. | An institutional leader uses the RIM's strategic dashboards to gain an overview of institutional research performance, enabling informed decisions about resource allocation and strategic direction. |
| Library&Repository Managers | Enhance discoverability of research outputs | Manage and curate institutional research outputs (papers, books, research datasets); ensure open-access compliance; enhance visibility and discoverability of research outputs; support long-term digital preservation. | A library manager curates and enhances discoverability of research outputs through seamless integration with institutional repositories and open-access databases. |
| System Administrators | Maintain university research information infrastructure | Maintain secure, integrated, reliable research information infrastructure; support data interoperability across institutional systems; manage user access and permissions; provide technical support and ensure data quality. | A system administrator ensures the smooth operation of the RIM, managing user permissions, data integrations, and maintaining system security. |
| External Collaborators | Foster effective research collaboration | Foster effective research collaboration; easily access and share relevant research information and outputs; streamline cross-institutional research processes; ensure compliance with joint research agreements. | An external collaborator (e.g., funding agency or research partner) accesses a customized, secure portal to view selected research outputs and project details. |

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Git
- Node.js and npm (for development)
- kubectl (for Kubernetes deployment)

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/myRIMS.git
   cd myRIMS
   ```

2. Generate SQL files for the CERIF data model:
   ```bash
   cd database/scripts
   chmod +x generate-sql.sh
   ./generate-sql.sh
   cd ../..
   ```

3. Start the PostgreSQL and Metabase services:
   ```bash
   docker compose up -d
   ```

   If you need to restart the services after making changes:
   ```bash
   chmod +x restart-services.sh
   ./restart-services.sh
   ```

4. Set up Airbyte separately using the official Docker Compose file:
   ```bash
   # Clone the Airbyte repository
   git clone https://github.com/airbytehq/airbyte.git
   cd airbyte
   
   # Start Airbyte
   docker compose up -d
   ```

5. Access the services:
   - Metabase UI: http://localhost:3000
   - Airbyte UI: http://localhost:8000 (default port for Airbyte)

### Initial Setup

1. **Database Setup**:
   - The database is automatically initialized with the CERIF data model
   - Default roles and permissions are created

2. **Metabase Setup**:
   - First-time setup will require creating an admin account
   - Connect to the PostgreSQL database using the credentials in the docker-compose.yml file
   - Create dashboards and visualizations for different roles
   - Note: If you encounter platform compatibility issues (especially on Apple M1/M2 Macs), consider using the cloud deployment option instead

3. **Airbyte Setup**:
   - Configure sources for external data (Scopus, OpenAlex, etc.)
   - Set up destinations to the PostgreSQL database
   - Create and schedule synchronization jobs

### Cloud Deployment

There are two options for cloud deployment:

#### Option 1: Simplified Docker Compose Deployment (Recommended)

This option is suitable for cloud platforms that support Docker Compose deployments with environment variables, volumes, and port mapping.

1. Clone the repository and create an `.env` file:
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

2. Upload the following files to your cloud platform:
   - `cloud-docker-compose.yml`
   - `.env` (adjust port values as needed for your cloud platform)
   - Dockerfiles for each component (database, metabase, airbyte)

3. Build the Docker images using your cloud platform's interface:
   - The database Dockerfile includes a multi-stage build that generates the SQL files for the CERIF data model
   - The Metabase and Airbyte Dockerfiles extend the official images with custom configurations

4. Deploy the application using your cloud platform's interface:
   - Use the `cloud-docker-compose.yml` file for configuration
   - Ensure all required ports are exposed as HTTPS if needed

5. After deployment, configure:
   - Set up Metabase dashboards for different user roles
   - Configure Airbyte connectors for your data sources
   - Set up scheduled data synchronization jobs

6. Access your application at the URLs provided by your cloud platform

For detailed instructions, see the [Cloud Deployment Guide](docs/cloud-deployment-guide.md).

#### Option 2: Kubernetes Deployment

For more advanced deployments on Kubernetes clusters:

1. Build and push Docker images:
   ```bash
   chmod +x build-and-push.sh
   ./build-and-push.sh [registry-url]
   ```

2. Deploy core components to Kubernetes:
   ```bash
   chmod +x deploy-k8s.sh
   ./deploy-k8s.sh [registry-url] [domain]
   ```

3. Deploy Airbyte separately using the official Airbyte Kubernetes manifests:
   ```bash
   # Follow the instructions at https://docs.airbyte.com/deploying-airbyte/on-kubernetes
   ```

4. Access the services:
   - Metabase UI: https://metabase.[domain]
   - Airbyte UI: https://airbyte.[domain] (after configuring Airbyte ingress)

## Development

### Project Structure

```
myRIMS/
├── docker-compose.yml          # Local development setup
├── README.md                   # Project documentation
├── database/
│   ├── init/                   # Database initialization scripts
│   │   ├── 01-schema.sql       # Generated from CERIF model
│   │   ├── 02-roles.sql        # Role definitions
│   │   └── 03-sample-data.sql  # Optional sample data
│   └── scripts/                # Utility scripts
│       └── parse-cerif.js      # Script to parse .txp file
├── metabase/
│   └── config/                 # Metabase configuration
├── airbyte/
│   └── config/                 # Airbyte configuration
└── k8s/                        # Kubernetes configuration for cloud
    ├── database.yaml
    ├── metabase.yaml
    └── airbyte.yaml
```

### Customization

- **Database Schema**: Modify the initialization scripts in `database/init/`
- **User Interface**: Customize Metabase dashboards and visualizations
- **Integration**: Configure Airbyte connectors for specific data sources

## Deployment

### Local Deployment

Use Docker Compose for local development and testing:

```bash
docker compose up -d
```

### Cloud Deployment

1. Push the repository to GitHub
2. Clone the repository on the cloud server
3. Use the Kubernetes configuration files in the `k8s/` directory for deployment

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [CERIF](https://www.eurocris.org/cerif/main-features-cerif) - Common European Research Information Format
- [euroCRIS](https://www.eurocris.org/) - The international organization for research information
