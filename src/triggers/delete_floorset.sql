/*
Filenname: delete_floorset.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When floorset is deleted from floorset table:

-Delete the floorset from the floorsets_fixtures table.

-Delete from the sales_data table, any sales_data
associated with the floorset.

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_Floorset
ON dbo.FLOORSETS
AFTER DELETE
AS
BEGIN
    DELETE FROM FLOORSETS_FIXTURES
    WHERE FLOORSET_TUID IN (SELECT TUID FROM deleted);
	
	DELETE FROM SALES_DATA
	WHERE FLOORSET_TUID IN (SELECT TUID FROM deleted);
END;
GO