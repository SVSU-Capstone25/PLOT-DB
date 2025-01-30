/*
Filenname: delete_fixture.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When a fixture is deleted from fixtures table,
delete the fixture from the floorsets_fixtures table

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_Fixture
ON dbo.FIXTURES
AFTER DELETE
AS
BEGIN
	/* Delete fixture records in the floorsets-fixtures
	association table when its TUID matches that deleted in floorsets */
    DELETE FROM FLOORSETS_FIXTURES
    WHERE FIXTURE_TUID IN (SELECT TUID FROM deleted);
END;
GO