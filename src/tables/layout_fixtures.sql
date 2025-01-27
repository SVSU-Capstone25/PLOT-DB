/*
Filenname: layout_fixtures.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Layout Fixtures
table for the database.

Association table for the layout and fixture tables.
Provides position of a given fixture on a given layout.

Written by: Andrew Miller
*/

-- Create layout fixtures table
CREATE TABLE Layout_Fixtures (
	LAYOUT_TUID INT,				/* TUID of Layout */
	FIXTURE_TUID INT,				/* TUID of fixture */
	X_POS DECIMAL(9,6),				/* X-Coordinate */
	Y_POS DECIMAL(9,6),				/* Y-Coordinate */
	PRIMARY KEY(LAYOUT_TUID, FIXTURE_TUID),
	FOREIGN KEY(LAYOUT_TUID) REFERENCES Layouts(TUID),
	FOREIGN KEY(FIXTURE_TUID) REFERENCES Fixtures(TUID)
);
GO