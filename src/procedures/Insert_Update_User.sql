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
-- 
-- Refactor: 4/13/2025
-- Added return of User TUID and fixed errors that were occuring on build.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Insert_User]
(
    @FIRST_NAME VARCHAR(747) = NULL,
    @LAST_NAME VARCHAR(747) = NULL,
    @EMAIL VARCHAR(320) = NULL,
    @PASSWORD VARCHAR(100) = NULL,
    @ROLE_TUID INT = NULL,
    @ACTIVE BIT = 1
)
AS
BEGIN
    DECLARE @USER_TUID INT

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
    SET @USER_TUID = SCOPE_IDENTITY();
    SELECT @USER_TUID AS USER_TUID;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Update_User]
(
    @TUID INT,
    @FIRST_NAME VARCHAR(747) = NULL,
    @LAST_NAME VARCHAR(747) = NULL,
    @EMAIL VARCHAR(320) = NULL,
    @PASSWORD VARCHAR(100) = NULL,
    @ROLE_TUID INT = NULL,
    @ACTIVE BIT = 1
)
AS
BEGIN
    -- This only update the fields that are provided (not NULL)
    UPDATE [dbo].[Users]
    SET 
        FIRST_NAME = COALESCE(@FIRST_NAME, FIRST_NAME), 
        LAST_NAME = COALESCE(@LAST_NAME, LAST_NAME), 
        EMAIL = COALESCE(@EMAIL, EMAIL), 
        PASSWORD = COALESCE(@PASSWORD, PASSWORD), 
        ROLE_TUID = COALESCE(@ROLE_TUID, ROLE_TUID), 
        ACTIVE = COALESCE(@ACTIVE, ACTIVE)
    WHERE TUID = @TUID;
END
GO


CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_User]
(
    @TUID INT = NULL,
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
    DECLARE @ROLE_TUID INT, @USER_TUID INT, @STORE_TUID INT, @RESULT_SET INT;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Get Role ID
        SET @ROLE_TUID = (
			SELECT TUID 
			FROM Roles 
			WHERE NAME = @ROLE_NAME
			);

        -- Insert or update user
        IF @TUID IS NULL
        BEGIN
            EXEC [dbo].[Insert_User] @FIRST_NAME, @LAST_NAME, @EMAIL, @PASSWORD, @ROLE_TUID
            SELECT @USER_TUID;
        END
        ELSE
        BEGIN
			EXEC [dbo].[Update_User] @TUID, @FIRST_NAME, @LAST_NAME, @EMAIL, @PASSWORD, @ROLE_TUID, @ACTIVE
            SELECT 200 AS Response;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END;
GO