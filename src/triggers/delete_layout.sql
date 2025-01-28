/*
Filenname: delete_layout.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
When layout is deleted from layout table,
Delete the layout from the layout_fixtures table
and from the sales_data table, any sales_data
associated with the layout.

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_Layout
AFTER DELETE
ON dbo.LAYOUT
AFTER DELETE AS
BEGIN
	DELETE FROM layout_fixtures
	WHERE Layout_TUID = OLD.TUID;
	
	DELETE FROM sales_data
	WHERE layout_TUID = OLD.TUID;
END;
GO