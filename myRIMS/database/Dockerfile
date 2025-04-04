FROM postgres:15

# Set environment variables
ENV POSTGRES_USER=rims_admin
ENV POSTGRES_PASSWORD=rims_password
ENV POSTGRES_DB=rims_db

# Copy initialization scripts
COPY ./init /docker-entrypoint-initdb.d/

# Set the working directory
WORKDIR /docker-entrypoint-initdb.d

# Expose the PostgreSQL port
EXPOSE 5432

# Set the default command
CMD ["postgres"]
