SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/17/2025
-- Description: 
-- This trigger is created to make sure the 
-- root user CANNOT be delete whatsoever.
-- =============================================

CREATE OR ALTER TRIGGER [dbo].[trg_PreventRootUserDelete]
ON [dbo].[Users]
AFTER DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted WHERE TUID = 0)
    BEGIN
        RAISERROR('The root user cannot be deleted.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

ALTER TABLE [dbo].[Users] ENABLE TRIGGER [trg_PreventRootUserDelete]
GO


