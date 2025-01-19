#!/bin/bash

# ! If you're running windows, make sure this file is 
# ! LF instead of CLRF in VSCode on the bottom right

# Wait 60 seconds for SQL Server to start up
DBSTATUS=1
ERRCODE=1
i=0

while [[ $DBSTATUS -ne 0 ]] && [[ $i -lt 60 ]] && [[ $ERRCODE -ne 0 ]]; do
  i=$((i+1))
  DBSTATUS=$(/opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SET NOCOUNT ON; SELECT SUM(state) FROM sys.databases WHERE state_desc = 'ONLINE'" -h -1 -t 1 | tr -d '[:space:]')
  ERRCODE=$?
  sleep 1
done

if [[ $DBSTATUS -ne 0 || $ERRCODE -ne 0 ]]; then
  echo "SQL Server took more than 60 seconds to start up or one or more databases are not in an ONLINE state."
  exit 1
fi

# Ensure the target database exists
echo "Ensuring the database $DB_NAME exists..."
/opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '$DB_NAME') CREATE DATABASE [$DB_NAME];"
if [ $? -ne 0 ]; then
  echo "Failed to create or verify the database $DB_NAME. Exiting."
  exit 1
fi

# Function to run SQL scripts
run_sql_scripts() {
  local dir=$1
  echo -e "\nRunning scripts in $dir..."

  # Check if the directory exists
  if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist. Skipping."
    return
  fi

  # Check if there are .sql files in the directory
  if compgen -G "$dir/*.sql" > /dev/null; then
    for file in "$dir"/*.sql; do
      echo "Executing $file..."
      /opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P "$MSSQL_SA_PASSWORD" -C -d "$DB_NAME" -i "$file"
      if [ $? -ne 0 ]; then
        echo "Error executing $file. Exiting."
        exit 1
      fi
    done
  else
    echo "No .sql files found in $dir. Skipping."
  fi
}

echo -e "\nSQL Server is ready. Starting initialization."

# Run SQL scripts in order of dependencies
run_sql_scripts "/usr/config/src/tables"
run_sql_scripts "/usr/config/src/functions"
run_sql_scripts "/usr/config/src/views"
run_sql_scripts "/usr/config/src/procedures"
run_sql_scripts "/usr/config/src/triggers"

# Final message
echo -e "\nDatabase initialization complete."
