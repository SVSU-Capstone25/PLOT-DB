/*
Filename: Sales.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Sales table for the database.

Written by: Krzysztof Hejno
*/

-- Create Sales Table
CREATE TABLE Sales (
    TUID IDENTITY(1,1) PRIMARY KEY,
    FILENAME VARCHAR(100) NOT NULL UNIQUE,   --may need to be unique to avoid overriding files
    FILEPATH VARBINARY(1) NOT NULL,
    CAPTURE_DATE DATETIME NOT NULL, 
    DATE_UPLOADED DATETIME NOT NULL,
    FLOORSET_TUID INT,
    FOREIGN KEY (FLOORSET_TUID) REFERENCES floorset(TUID)
);
GO