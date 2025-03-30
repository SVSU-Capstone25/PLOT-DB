/*
Filenname: trg_DeleteForeignKeysForFixtureOnDelete.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When a fixture is deleted from fixtures table,
delete the fixture from the floorsets_fixtures table
Note: Uses "Instead of Delete" and does the delete at the end.

Written by: Andrew Miller
*/

CREATE TRIGGER trg_DeleteForeignKeysForFixtureOnDelete
ON dbo.FIXTURES
INSTEAD of DELETE
AS
BEGIN
	/* Delete fixture records in the floorsets-fixtures
	association table when its TUID matches that deleted in floorsets */
    DELETE FROM FLOORSETS_FIXTURES
    WHERE FIXTURE_TUID IN (SELECT TUID FROM deleted);

    -- Delete from fixtures table
	DELETE FROM FIXTURES
	WHERE TUID IN (SELECT TUID FROM deleted);
END;
GO