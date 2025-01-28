/*
Filenname: delete_store.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
Trigger so that when store is deleted from store table,
layouts from that store are deleted from layouts table,
and fixtures from that store are deleted from fixtures table

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_Store
AFTER DELETE
ON dbo.STORE
AFTER DELETE AS
BEGIN
	DELETE FROM access
	WHERE STORE_TUID = OLD.TUID;
	
	DELETE FROM layout
	WHERE TUID = OLD.TUID;
	
	DELETE FROM fixtures
	WHERE TUID = OLD.TUID;
END;
GO