/*
Filename: Store.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Store table for the database.

Written by: Zach Ventimiglia
*/

CREATE TABLE Store (
    TUID INT IDENTITY(1,1) NOT NULL,
    NAME VARCHAR(100) NOT NULL,
    ADDRESS VARCHAR(100) NOT NULL,
    CITY VARCHAR(100) NOT NULL,
    STATE VARCHAR(25) NOT NULL,
    ZIP VARCHAR(10) NOT NULL,
    WIDTH INT NULL,
    HEIGHT INT NULL,
    BLUEPRINT_IMAGE VARBINARY(MAX) NULL,
    PRIMARY KEY (TUID),
    UNIQUE (TUID)
);
GO