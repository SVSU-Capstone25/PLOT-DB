/*
Filenname: delete_floorset.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When a fixture is deleted from fixtures table,
delete the fixture from the floorset_fixtures table.

Written by: Andrew Miller
*/
CREATE TRIGGER Delete_Floorset
ON dbo.FLOORSETS
AFTER DELETE
AS
BEGIN
	/* Delete Floorset records in the floorsets-fixtures
	association table when its TUID matches that deleted in floorsets */
    DELETE FROM FLOORSET_FIXTURES
    WHERE FLOORSET_TUID IN (SELECT TUID FROM deleted);
END;
GO