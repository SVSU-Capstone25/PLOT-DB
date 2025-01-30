/*
Filename: Fixtures.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Fixtures table for the database.

Written by: Zach Ventimiglia
*/

CREATE TABLE Fixtures (
    TUID INT IDENTITY(1,1) NOT NULL,
    NAME VARCHAR(100) NOT NULL,
    WIDTH INT NOT NULL,
    HEIGHT INT NOT NULL,
    LF_CAP DECIMAL(10,2) NOT NULL,
    HANGER_STACK INT NOT NULL,
    TOT_LF DECIMAL(10,2) NOT NULL,
    ICON VARBINARY(MAX) NOT NULL,
    STORE_TUID INT NOT NULL,
    PRIMARY KEY (TUID),
    UNIQUE (TUID),
    INDEX TUID_idx (STORE_TUID),
    CONSTRAINT STORE_TUIDX FOREIGN KEY (STORE_TUID) REFERENCES Store(TUID)
);