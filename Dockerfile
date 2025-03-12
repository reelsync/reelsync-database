# Use the official PostgreSQL image from Docker Hub
FROM postgres:17.1

# Set environment variables
ENV POSTGRES_USER=reelsyncuser
ENV POSTGRES_PASSWORD=reelsyncpassword
ENV POSTGRES_DB=reelsync

# Copy initialization scripts from the local directory to the 
# container's initialization directory
COPY ./db/init/init.sql /docker-entrypoint-initdb.d/

# Expose the default PostgreSQL port
EXPOSE 5432