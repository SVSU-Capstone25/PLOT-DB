-- =============================================
-- Author:      <Krzysztof.Hejno>
-- Create Date: <2/11/2025>
-- Description: <This trigger will delete any previous sales data linked to the same floorset when new data is inserted>
-- =============================================

CREATE TRIGGER [dbo].[trg_DeleteOldSalesOnInsert]
ON [dbo].[Sales]
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Sales WHERE FLOORSET_TUID IN (SELECT FLOORSET_TUID FROM inserted)
	AND TUID NOT IN (SELECT TUID FROM inserted);

END;
GO

ALTER TABLE [dbo].[Sales] ENABLE TRIGGER [trg_DeleteOldSalesOnInsert]
GO

