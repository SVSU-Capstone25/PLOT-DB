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
-- =============================================
CREATE   PROCEDURE [dbo].[Insert_Update_User]
(
    @ID INT = NULL,
    @FIRSTNAME VARCHAR(747) = NULL,
    @LASTNAME VARCHAR(747) = NULL,
    @EMAIL VARCHAR(320) = NULL,
    @PASSWORD VARCHAR(100) = NULL,
    @ROLENAME VARCHAR(100) = NULL,
    @STORENAME VARCHAR(100) = NULL,
    @ACTIVE BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ROLETUID INT, @USERTUID INT, @STORETUID INT, @RESULTSET INT;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Get Role ID
        SET @ROLETUID = (
			SELECT TUID 
			FROM Roles 
			WHERE NAME = @ROLENAME
			);

        -- Insert or update user
        IF @ID IS NULL
        BEGIN
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
				@FIRSTNAME, 
				@LASTNAME, 
				@EMAIL, 
				@PASSWORD, 
				@ROLETUID, 
				@ACTIVE
			);
            
            -- Get newly inserted user ID
            SET @USERTUID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
			-- This only update the fields that are provided (not NULL)
            UPDATE [dbo].[Users]
            SET 
				FIRST_NAME = COALESCE(@FIRSTNAME, FIRST_NAME), 
                LAST_NAME = COALESCE(@LASTNAME, LAST_NAME), 
                EMAIL = COALESCE(@EMAIL, EMAIL), 
                PASSWORD = COALESCE(@PASSWORD, PASSWORD), 
                ROLE_TUID = COALESCE(@ROLETUID, ROLE_TUID), 
                ACTIVE = COALESCE(@ACTIVE, ACTIVE)
            WHERE TUID = @ID;

            SET @USERTUID = @ID;
        END

        -- Get Store ID
        SET @STORETUID = (
			SELECT TUID 
			FROM Stores 
			WHERE NAME = @STORENAME
		);

        -- Check if user-store association already exists
        SET @RESULTSET = (
			SELECT COUNT(*) 
			FROM Access 
			WHERE USER_TUID = @USERTUID AND STORE_TUID = @STORETUID
		);

        -- Insert into Access table if not exists
        IF @RESULTSET = 0
        BEGIN
            INSERT INTO [dbo].[Access] 
			(
				USER_TUID, 
				STORE_TUID
			) 
			VALUES 
			(
				@USERTUID, 
				@STORETUID
			);
        END

        COMMIT TRANSACTION;
        SELECT 'OK 200' AS Response;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END;
GO