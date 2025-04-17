SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
Filename: Insert_Update_Stores.sql
Part of Project: PLOT/PLOT-DB/src/procedures

File Purpose:
This file contains the Stored Procedure for inserting and updating the Store table.
This also inserts the users into the access table for thea store.

Written by: Andrew Fulton

Updated 3/26/2025
By: Zach Ventimiglia
Reasoning: Throwing errors about duplicates inserting in Access table.
Resolved by try/catch of filtering.

Updated 3/30/2025
By: Zach Ventimiglia
Reasoning: Needing 2 separate updates when calling the procedure due to UI constraints
Resolved by marking variables as null and writing if statements in the update
conditions. 1 updates just the width and length and 1 updates the public info. 

Updated 4/2/2025
By: Andrew Miller
Reasoning: Changed "Height" to "Length" for stores
*/

CREATE OR ALTER PROCEDURE [dbo].[Insert_Store] (
	@TUID INT = NULL,
    @NAME VARCHAR(100) = NULL,
    @ADDRESS VARCHAR(100) = NULL,
    @CITY VARCHAR(100) = NULL,
    @STATE VARCHAR(25) = NULL,
    @ZIP VARCHAR(10) = NULL,
    @WIDTH INT = NULL,
    @LENGTH INT = NULL,
    @BLUEPRINT_IMAGE VARBINARY(MAX) = NULL,
    @USER_TUIDS VARCHAR(MAX) = NULL
)
AS
BEGIN
    --insert the new store
    INSERT INTO Stores
	(
		NAME, 
		ADDRESS, 
		CITY, 
		STATE, 
		ZIP, 
		WIDTH, 
		LENGTH, 
		BLUEPRINT_IMAGE
	)
    VALUES 
	(
		@NAME,
		@ADDRESS, 
		@CITY, 
		@STATE, 
		@ZIP, 
		@WIDTH, 
		@LENGTH, 
		@BLUEPRINT_IMAGE
	)

    --int to hold the new store TUID
    DECLARE @NEW_STORE_TUID INT = SCOPE_IDENTITY()

    --INSERT all Owners into the Access table for the new store
    INSERT INTO Access (USER_TUID, STORE_TUID)
    	SELECT Users.TUID, @NEW_STORE_TUID
    	FROM Users
    	WHERE Users.ROLE_TUID = 1 --Owner TUID is 1 in DB

    --INSERT users into the Access table for the new store
	IF @USER_TUIDS IS NOT NULL AND @USER_TUIDS <> ''
	BEGIN
		INSERT INTO Access (USER_TUID, STORE_TUID)
		SELECT CAST(VALUE AS INT), @NEW_STORE_TUID
		FROM STRING_SPLIT(@USER_TUIDS, ',') AS split
		WHERE NOT EXISTS (
			SELECT 1 
			FROM Access 
			WHERE Access.USER_TUID = CAST(split.VALUE AS INT)
				AND Access.STORE_TUID = @NEW_STORE_TUID
		)
	END
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Update_Store] ( 
	@TUID INT, 
    @NAME VARCHAR(100) = NULL,
    @ADDRESS VARCHAR(100) = NULL,
    @CITY VARCHAR(100) = NULL,
    @STATE VARCHAR(25) = NULL,
    @ZIP VARCHAR(10) = NULL,
    @WIDTH INT = NULL,
    @LENGTH INT = NULL,
    @BLUEPRINT_IMAGE VARBINARY(MAX) = NULL,
    @USER_TUIDS VARCHAR(MAX) = NULL
)
AS
BEGIN
	UPDATE Stores
	SET
		NAME = COALESCE(@NAME, NAME),
		ADDRESS = COALESCE(@ADDRESS, ADDRESS),
		CITY = COALESCE(@CITY, CITY),
		STATE = COALESCE(@STATE, STATE),
		ZIP = COALESCE(@ZIP, ZIP),
		WIDTH = COALESCE(@WIDTH, WIDTH),
		LENGTH = COALESCE(@LENGTH, LENGTH),
		BLUEPRINT_IMAGE = COALESCE(@BLUEPRINT_IMAGE, BLUEPRINT_IMAGE)
	WHERE TUID = @TUID

	-- INSERT users into the Access table for the new store, but only if they don't already exist
	IF @USER_TUIDS IS NOT NULL AND @USER_TUIDS <> ''
	BEGIN
		-- Delete all existing access records for this store
		DELETE FROM Access
			WHERE STORE_TUID = @TUID;

		--INSERT all Owners into the Access table for the new store
		INSERT INTO Access (USER_TUID, STORE_TUID)
			SELECT Users.TUID, @TUID
			FROM Users
			WHERE Users.ROLE_TUID = 1 --Owner TUID is 1 in DB

		INSERT INTO Access (USER_TUID, STORE_TUID)
		SELECT VALUE, @TUID
		FROM STRING_SPLIT(@USER_TUIDS, ',') AS split
		WHERE NOT EXISTS (
			SELECT 1
			FROM Access AS a
			WHERE a.USER_TUID = split.VALUE
			  AND a.STORE_TUID = @TUID
		)
	END

END
GO

CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Store]
    --TUID null for deciding if it should insert or update
	@TUID INT = NULL,  
    @NAME VARCHAR(100) = NULL,
    @ADDRESS VARCHAR(100) = NULL,
    @CITY VARCHAR(100) = NULL,
    @STATE VARCHAR(25) = NULL,
    @ZIP VARCHAR(10) = NULL,
    @WIDTH INT = NULL,
    @LENGTH INT = NULL,
    @BLUEPRINT_IMAGE VARBINARY(MAX) = NULL,
    @USER_TUIDS VARCHAR(MAX) = NULL --Comma seperated list of user TUIDs
AS
BEGIN
    BEGIN TRY
		--show number of rows affected
    	SET NOCOUNT ON

    	IF @TUID IS NULL OR @TUID = 0
    	BEGIN
        	EXEC [dbo].[Insert_Store] @TUID, @NAME, @ADDRESS, @CITY, @STATE, @ZIP, @WIDTH, @LENGTH, @BLUEPRINT_IMAGE, @USER_TUIDS
    	END
		ELSE 
    	BEGIN
			EXEC [dbo].[Update_Store] @TUID, @NAME, @ADDRESS, @CITY, @STATE, @ZIP, @WIDTH, @LENGTH, @BLUEPRINT_IMAGE
    	END

		--Return the newly inserted store TUID
    	SELECT 200 AS Response
	END TRY
	BEGIN CATCH
		SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails
	END CATCH
END
GO
