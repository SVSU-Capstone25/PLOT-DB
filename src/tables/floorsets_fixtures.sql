/*
Filenname: floorsets_fixtures.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Floorsets Fixtures
table for the database.

Association table for the floorsets and fixture tables.
Provides position of a given fixture on a given floorset.
Provides allocated linear feet, and category of merchandise.

Written by: Andrew Miller
*/

-- Create floorsets_fixtures table
CREATE TABLE Floorsets_Fixtures (
	FLOORSET_TUID INT,							/* TUID of Floorset */
	FIXTURE_TUID INT,							/* TUID of Fixture */
	X_POS DECIMAL(9,6) NOT NULL,				/* X-Coordinate */
	Y_POS DECIMAL(9,6) NOT NULL,				/* Y-Coordinate */

	/* linear feet allocated to fixture */
	ALLOCATED_LF DECIMAL(10,2),

	/* Category of merchandise on fixture */					
	CATEGORY VARCHAR(100),

	/* Optional note, defaults as empty string */						
	NOTE VARCHAR(1000) NOT NULL DEFAULT '',
	
	PRIMARY KEY(FLOORSET_TUID, FIXTURE_TUID),
	FOREIGN KEY(FLOORSET_TUID) REFERENCES Floorsets(TUID),
	FOREIGN KEY(FIXTURE_TUID) REFERENCES Fixtures(TUID)
);
GO