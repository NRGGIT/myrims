FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY database/scripts/package*.json ./

# Install dependencies
RUN npm install

# Create directory structure
RUN mkdir -p database/scripts database/init

# Copy the script files
COPY database/scripts/parse-cerif.js database/scripts/

# Run the script to generate SQL files
WORKDIR /app
RUN node database/scripts/parse-cerif.js

FROM postgres:15

# Set environment variables
ENV POSTGRES_USER=rims_admin
ENV POSTGRES_PASSWORD=rims_password
ENV POSTGRES_DB=rims_db

# Copy initialization scripts from builder stage
COPY --from=builder /app/database/init/*.sql /docker-entrypoint-initdb.d/

# Set the working directory
WORKDIR /docker-entrypoint-initdb.d

# Expose the PostgreSQL port
EXPOSE 5432

# Set the default command
CMD ["postgres"]
