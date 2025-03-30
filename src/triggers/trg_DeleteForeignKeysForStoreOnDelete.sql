/*
Filenname: trg_DeleteForeignKeysForStoreOnDelete.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
Trigger so that when store is deleted from store table,
floorsets from that store are deleted from floorsets table,
and fixtures from that store are deleted from fixtures table

Written by: Andrew Miller
*/

CREATE TRIGGER trg_DeleteForeignKeysForStoreOnDelete
ON dbo.STORES
AFTER DELETE
AS
BEGIN
	/* Delete records from the access table matching the store's TUID */
    DELETE FROM ACCESS
    WHERE STORE_TUID IN (SELECT TUID FROM deleted);

	/* Delete records from the floorsets table matching the store's TUID */
	DELETE FROM FLOORSETS
	WHERE STORE_TUID IN (SELECT TUID FROM deleted);

	/* Delete records from the fixtures table matching the store's TUID */
	DELETE FROM FIXTURES
	WHERE STORE_TUID IN (SELECT TUID FROM deleted);
END;
GO