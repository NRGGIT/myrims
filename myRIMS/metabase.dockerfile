FROM metabase/metabase:latest

# Set environment variables
ENV MB_DB_TYPE=postgres
ENV MB_DB_DBNAME=metabase
ENV MB_DB_PORT=5432
ENV MB_DB_USER=rims_admin
ENV MB_DB_PASS=rims_password
ENV MB_DB_HOST=postgres
ENV JAVA_OPTS="-Xmx2g"

# Expose the Metabase port
EXPOSE 3000

# Use a non-root user if possible
USER metabase

# Set the default command
CMD ["java", "-jar", "metabase.jar"]
