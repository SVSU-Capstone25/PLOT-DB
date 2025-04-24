#!/bin/bash

# ! If you're running windows, make sure this file is
# ! LF instead of CLRF in VSCode on the bottom right

# Author: Clayton Cook <work@claytonleonardcook.com>

export SQLCMDPASSWORD="$MSSQL_SA_PASSWORD"
export SQLCMDSERVER="localhost"
export SQLCMDUSER="sa"

set -e

# Wait 60 seconds for SQL Server to start up
DBSTATUS=1
ERRCODE=1
i=0

# Wait for SQL Server to be ready to accept connections
echo "⏳  Waiting for SQL Server to start... ⏳"
until /opt/mssql-tools18/bin/sqlcmd -C -Q "SET NOCOUNT ON; SELECT 1;" &>/dev/null; do
  sleep 1
done
echo "✅  SQL Server is up! ✅"

# Ensure the target database exists, retry up to 10 times
echo "ℹ️  Ensuring the database $DB_NAME exists... ℹ️"
CREATE_SUCCESS=1
attempt=0
while [[ $CREATE_SUCCESS -ne 0 && $attempt -lt 10 ]]; do
  /opt/mssql-tools18/bin/sqlcmd -C -Q "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '$DB_NAME') CREATE DATABASE [$DB_NAME];"
  CREATE_SUCCESS=$?
  attempt=$((attempt + 1))
  if [[ $CREATE_SUCCESS -ne 0 ]]; then
    echo "⚠️  Attempt $attempt: Failed to create or verify the database $DB_NAME"
    echo "⏲️  Retrying in 2 seconds..."
    sleep 2
  fi
done

if [[ $CREATE_SUCCESS -ne 0 ]]; then
  echo "⛔  Failed to create or verify the database $DB_NAME after $attempt attempts. Exiting."
  exit 1
fi

# Function to run SQL scripts
run_sql_scripts() {
  local dir=$1
  echo -e "\n🏃  Running scripts in $dir..."

  # Check if the directory exists
  if [ ! -d "$dir" ]; then
    echo "⏭️  Directory $dir does not exist. Skipping."
    return
  fi

  # Check if there are .sql files in the directory
  if compgen -G "$dir/*.sql" >/dev/null; then
    for file in "$dir"/*.sql; do
      echo "▶️  Executing $file..."

      # Capture the output of sqlcmd
      output=$(/opt/mssql-tools18/bin/sqlcmd -C -d "$DB_NAME" -i "$file")

      # If there is output, log the file name and the output
      if [ -n "$output" ]; then
        echo -e "\n⚠️  --- Executing $file --- ⚠️\n" >>/tmp/sql.log
        echo "$output" >>/tmp/sql.log
      fi

      if [ $? -ne 0 ]; then
        echo "⛔  Error executing $file. Exiting."
        exit 1
      fi
    done
  else
    echo "⏭️  No .sql files found in $dir. Skipping."
  fi
}

echo -e "\n✅  SQL Server is ready. Starting initialization. ✅"

# echo -e "\n🧹  Clearing database... 🧹"
# /opt/mssql-tools18/bin/sqlcmd -C -d "$DB_NAME" -i "/usr/config/src/delete.sql" >>/tmp/sql.log

# Run SQL scripts in order of dependencies
run_sql_scripts "/usr/config/src/tables"
run_sql_scripts "/usr/config/src/functions"
run_sql_scripts "/usr/config/src/views"
run_sql_scripts "/usr/config/src/procedures"
run_sql_scripts "/usr/config/src/triggers"

echo -e "\n🌱  Seeding database... 🌱"
/opt/mssql-tools18/bin/sqlcmd -C -d "$DB_NAME" -i "/usr/config/src/seed.sql" >>/tmp/sql.log

# Final message
echo -e "\n✅  Database initialization complete. ✅"

echo -e "\n⚠️ ⚠️ ⚠️  SQL Logs: ⚠️ ⚠️ ⚠️"
cat /tmp/sql.log

# Let Docker know that container is healthy
touch /tmp/ready
