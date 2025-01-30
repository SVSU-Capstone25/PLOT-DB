/*
Filename: layouts.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create Floorsets table for the database.

Written by: Andrew Fulton
*/

--Create Floorsets Table
CREATE TABLE Floorsets (
    TUID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    STORE_TUID INT NOT NULL,
    DATE_CREATED DATETIME NOT NULL,
    CREATED_BY INT NOT NULL,
    DATE_MODIFIED DATETIME NOT NULL,
    MODIFIED_BY INT NOT NULL,
    FOREIGN KEY (STORE_TUID) REFERENCES Store(TUID)
);
GO