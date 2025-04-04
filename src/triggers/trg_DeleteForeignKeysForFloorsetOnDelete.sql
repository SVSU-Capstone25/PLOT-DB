/*
Filenname: trg_DeleteForeignKeysForFloorsetOnDelete.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When a floorset is deleted from floorsets table,
delete the fixture from the floorset_fixtures table.
Note: Uses "Instead of Delete" and does the delete at the end.

Written by: Andrew Miller
*/
CREATE TRIGGER trg_DeleteForeignKeysForFloorsetOnDelete
ON dbo.FLOORSETS
INSTEAD OF DELETE
AS
BEGIN
		/* Delete floorset records in the floorsets-fixtures
	association table when its TUID matches that deleted in floorsets */
	DELETE FROM FLOORSETS_FIXTURES
	WHERE FLOORSET_TUID IN (SELECT TUID FROM deleted);

	/* Delete sales data records in database associated with floorset */
	DELETE FROM SALES
	WHERE FLOORSET_TUID IN (SELECT TUID FROM deleted);

	-- Then, delete from the floorsets table
	DELETE FROM FLOORSETS
	WHERE TUID IN (SELECT TUID FROM deleted);
END;
GO