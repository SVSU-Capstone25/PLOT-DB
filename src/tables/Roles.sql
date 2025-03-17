/*
Filenname: roles.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Roles table for the database.

Written by: Andrew Miller
*/

--Create Roles Table--

CREATE TABLE Roles (

	/* ID of Role - Identity Sets TUID as Autoincremented */
	TUID INT IDENTITY(1,1) PRIMARY KEY,

	/* Name of Role */
	NAME VARCHAR(100) NOT NULL
);
GO