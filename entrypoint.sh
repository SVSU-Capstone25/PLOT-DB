#!/bin/bash

# Start the script to create the DB
/usr/config/init.sh &

# Start SQL Server
/opt/mssql/bin/sqlservr
