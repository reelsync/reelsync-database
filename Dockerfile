# Use the official PostgreSQL image from Docker Hub
FROM postgres:17.1

# Set environment variables
ENV POSTGRES_USER=reelsync
ENV POSTGRES_PASSWORD=reelsync
ENV POSTGRES_DB=reelsync

# Expose the default PostgreSQL port
EXPOSE 5432