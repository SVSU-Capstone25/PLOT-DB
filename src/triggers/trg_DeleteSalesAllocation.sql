SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Zach Ventimiglia
-- Create Date: 4/7/2025
-- Description: 
-- Trigger will delete all sales allocations
-- associated with a removed sales file
-- =============================================

CREATE TRIGGER [dbo].[trg_DeleteSalesAllocation]
ON [dbo].[Sales]
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

    DELETE SA
    FROM dbo.Sales_Allocation AS SA
    INNER JOIN DELETED AS D ON SA.TUID = D.TUID;

END;
GO

ALTER TABLE [dbo].[Sales] ENABLE TRIGGER [trg_DeleteOldSalesOnInsert]
GO
