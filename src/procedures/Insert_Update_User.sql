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
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Update_User]
(
	@ID INT = NULL,
	@FIRSTNAME VARCHAR(747) = NULL,
	@LASTNAME VARCHAR(747) = NULL,
	@EMAIL VARCHAR(320) = NULL,
	@PASSWORD VARCHAR(100) = NULL,
	@ROLENAME VARCHAR(100) = NULL,
	@STORENAME VARCHAR(100) = NULL,
	@ACTIVE BIT = 1		--- it is unknown if this will be necessary
)
AS
BEGIN

	SET NOCOUNT ON;

	-- Making a ROLE_TUID variable for better insertion
	DECLARE @ROLETUID INT;
	SET @ROLETUID = 
	(							--******************************
	SELECT TUID					--
		FROM Roles				-- Fills in the ROLE_TUID Column
		WHERE NAME = @ROLENAME	--
	)							--******************************

	BEGIN TRY
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
				)
				SELECT 'OK 200' AS Response
			END
		ELSE
			BEGIN
				UPDATE [dbo].[Users]
				SET
					FIRST_NAME = @FIRSTNAME,
					LAST_NAME = @LASTNAME,
					EMAIL = @EMAIL,
					PASSWORD = @PASSWORD,
					ROLE_TUID = @ROLETUID,
					ACTIVE = @ACTIVE
				WHERE TUID = @ID
				SELECT 'OK 200' AS Response
		END
	END TRY
	BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;

	-- MARK USERS WITH ASSOCIATION BETWEEN STORE AND USERS
	BEGIN TRY
		INSERT INTO [dbo].[Access]
		(
			USER_TUID,
			STORE_TUID
		)
		VALUES
		(
			(							--******************************
			SELECT TUID					--
				FROM Users				-- Fills in the USER_TUID Column
				WHERE EMAIL = @EMAIL	--
			),							--******************************
			(							--******************************
			SELECT TUID					--
				FROM STORE				-- Fills in the STORE_TUID Column
				WHERE NAME = @STORENAME	--
			)							--******************************
		)
		SELECT 'OK 200' AS Response
	END TRY
	BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END