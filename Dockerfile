# Dockerfile

# Use the official PostGIS image as the base
# This image already includes PostgreSQL 16 and PostGIS 3.4
FROM postgis/postgis:16-3.4

# Add the PostgreSQL APT repository key and source list
# The postgis/postgis image often already has this, but explicitly adding it ensures it's there
# and that we can get the postgresql-16-pgvector package.
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    lsb-release \
    --no-install-recommends && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update

# Install the pgvector package for PostgreSQL 16
# This package contains the pre-compiled pgvector extension.
RUN apt-get install -y postgresql-16-pgvector --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# No need to clone git, run make, install compilers, or create symlinks!
# The base image already has PostgreSQL and PostGIS, and we're installing pgvector as a package.

# Keep the default entrypoint and command from the base PostGIS image
# (No need to explicitly define CMD or USER unless you want to change behavior)