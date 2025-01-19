# Base image for SQL Server
FROM mcr.microsoft.com/mssql/server:2022-latest

# Switch to root user to perform privileged actions
USER root

# Working directory inside the container
RUN mkdir -p /usr/config
WORKDIR /usr/config

# Copy your SQL scripts into the container
COPY . /usr/config

# Make the initialization script executable
RUN chmod +x /usr/config/entrypoint.sh
RUN chmod +x /usr/config/init.sh

# Expose SQL Server port
EXPOSE 1433

CMD ["./entrypoint.sh"]
