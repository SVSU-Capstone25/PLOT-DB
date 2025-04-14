#!/bin/bash

# ! If you're running windows, make sure this file is
# ! LF instead of CLRF in VSCode on the bottom right

# Start the script to create the DB
/usr/config/init.sh &

# Start SQL Server
/opt/mssql/bin/sqlservr
