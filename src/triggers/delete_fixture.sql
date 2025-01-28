/*
Filenname: delete_fixture.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When fixture is deleted from fixtures table,
Delete the fixture from the layout_fixtures table

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_Fixture
AFTER DELETE
ON dbo.FIXTURES
AFTER DELETE AS
BEGIN
	DELETE FROM layout_fixtures
	WHERE fixture_TUID = OLD.TUID;
END;
Go
