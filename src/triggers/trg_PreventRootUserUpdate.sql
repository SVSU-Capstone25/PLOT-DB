SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/17/2025
-- Description: 
-- This trigger is so no one can update the root 
-- user whatsoever.
-- =============================================

CREATE OR ALTER TRIGGER [dbo].[trg_PreventRootUserUpdate]
ON [dbo].[Users]
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE TUID = 0)
    BEGIN
        RAISERROR('The root user cannot be updated.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

ALTER TABLE [dbo].[Users] ENABLE TRIGGER [trg_PreventRootUserUpdate]
GO
