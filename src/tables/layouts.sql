/*
Filename: layouts.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Layouts table for the database.

Written by: Andrew Fulton
*/

--Create Layouts Table
CREATE TABLE Layouts (
    TUID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    STORE_TUID INT NOT NULL,
    DATE_CREATED DATETIME NOT NULL,
    CREATED_BY INT NOT NULL,
    DATE_MODIFIED DATETIME NOT NULL,
    MODIFIED_BY INT NOT NULL,
    FOREIGN KEY (STORE_TUID) REFERENCES Stores(TUID)
);
GO