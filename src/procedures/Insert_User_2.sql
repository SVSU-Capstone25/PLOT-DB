SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 2/13/2025
-- Description: 
-- This Procedure inserts or updates a row to the Users Table as well as the assocation table Access Table.
-- When the user is added or modified, the Access table also gets modified.

-- Refactored: 3/29/2025
-- Ran transactions when inserting into 2 seperate tables due to failures.
-- Ensures that either both operations succeed or none does.
-- 
-- Refactor: 4/7/2025
-- Removed the inserting store access (no store name parameter)
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Insert_User_2]
(
    --@TUID INT = NULL,
    @FIRST_NAME VARCHAR(747) = NULL,
    @LAST_NAME VARCHAR(747) = NULL,
    @EMAIL VARCHAR(320) = NULL,
    @PASSWORD VARCHAR(100) = NULL,
    @ROLE_NAME VARCHAR(100) = NULL,
    @ACTIVE BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ROLE_TUID INT;

    -- Get Role ID
    SET @ROLE_TUID = (
        SELECT TUID 
        FROM Roles 
        WHERE NAME = @ROLE_NAME
        );

    INSERT INTO [dbo].[Users] 
    (
        FIRST_NAME, 
        LAST_NAME, 
        EMAIL, 
        PASSWORD, 
        ROLE_TUID, 
        ACTIVE
    )
    VALUES 
    (
        @FIRST_NAME, 
        @LAST_NAME, 
        @EMAIL, 
        @PASSWORD, 
        @ROLE_TUID, 
        @ACTIVE
    );
    
    -- Get newly inserted user ID
    -- SET @TUID = SCOPE_IDENTITY();
    --SET @OUT_TUID = SCOPE_IDENTITY();
    --SELECT 200 AS Response UNION ALL SELECT @OUT_TUID AS TUID
    --SELECT 200 AS Response;
    SELECT SCOPE_IDENTITY() AS Response;
END
GO