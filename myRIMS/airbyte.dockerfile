FROM airbyte/server:latest

# Set environment variables
ENV DATABASE_HOST=airbyte-db
ENV DATABASE_PORT=5432
ENV DATABASE_DB=airbyte
ENV DATABASE_USER=airbyte
ENV DATABASE_PASSWORD=airbyte

# Expose the Airbyte port
EXPOSE 8001

# Set volumes
VOLUME ["/tmp/workspace", "/data"]

# Use a non-root user if possible
USER airbyte

# Set the default command
CMD ["java", "-jar", "airbyte.jar"]
