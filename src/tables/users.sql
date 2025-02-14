/*
Filename: users.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Users table for the database.

Written by: Andrew Fulton
*/

-- Create Users Table
CREATE TABLE Users (
    TUID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(747) NOT NULL,
    LAST_NAME VARCHAR(747) NOT NULL,
    EMAIL VARCHAR(320) NOT NULL UNIQUE, --I made email unique as well (differnt from SRS)
    PASSWORD VARCHAR(100) NOT NULL,
    ROLE_TUID INT,
    ACTIVE BIT NOT NULL DEFAULT 1,      --deafult of being an active employee
    FOREIGN KEY (ROLE_TUID) REFERENCES Roles(TUID)
);
GO