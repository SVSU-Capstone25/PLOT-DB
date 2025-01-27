/*
Filenname: roles.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Roles table for the database.

Written by: Andrew Miller
*/

--Create Roles Table--

CREATE TABLE Roles (
	TUID INT PRIMARY KEY,			/* ID of Role */
	NAME VARCHAR(100) NOT NULL		/* Name of Role */
);
GO