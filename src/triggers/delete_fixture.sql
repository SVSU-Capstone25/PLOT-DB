/*
Filenname: delete_fixture.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When fixture is deleted from fixtures table:

-Delete the fixture from the layout_fixtures table.

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_Fixture
ON dbo.FIXTURES
AFTER DELETE
AS
BEGIN
    DELETE FROM FLOORSETS_FIXTURES
    WHERE FIXTURE_TUID IN (SELECT TUID FROM deleted);
END;
Go
