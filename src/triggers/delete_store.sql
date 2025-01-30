/*
Filenname: delete_store.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
Trigger so that when store is deleted from store table:

-Store IDs for that store are deleted from the access table.

-Floorsets from that store are deleted from floorsets table.

-Fixtures from that store are deleted from fixtures table.

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_Store
AFTER DELETE
ON dbo.STORE
AFTER DELETE AS
BEGIN
	DELETE FROM ACCESS
	WHERE STORE_TUID = OLD.TUID;
	
	DELETE FROM FLOORSETS
	WHERE TUID = OLD.TUID;
	
	DELETE FROM FIXTURES
	WHERE TUID = OLD.TUID;
END;
GO