FROM metabase/metabase:latest

# Set environment variables
ENV MB_DB_TYPE=postgres
ENV MB_DB_DBNAME=metabase
ENV MB_DB_PORT=5432
ENV MB_DB_USER=rims_admin
ENV MB_DB_PASS=rims_password
ENV MB_DB_HOST=postgres
ENV JAVA_OPTS="-Xmx2g"
ENV MB_LOGGING_LEVEL=INFO
ENV MB_JETTY_HOST=0.0.0.0
ENV MB_JETTY_PORT=3000

# Expose the Metabase port
EXPOSE 3000

# Create necessary directories with appropriate permissions
USER root
RUN mkdir -p /app/log /tmp/metabase && \
    chmod -R 777 /app/log /tmp/metabase

# Set the default command
CMD ["java", "-jar", "metabase.jar"]
