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
    --show number of rows affected
    SET NOCOUNT ON;

    --IF @TUID is NULL or 0, insert a new store
    IF @TUID IS NULL OR @TUID = 0
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
		);

        --int to hold the new store TUID
        DECLARE @NEW_STORE_TUID INT = SCOPE_IDENTITY();

        --INSERT all Owners into the Access table for the new store
        INSERT INTO Access (USER_TUID, STORE_TUID)
        SELECT Users.TUID, @NEW_STORE_TUID
        FROM Users
        WHERE Users.ROLE_TUID = 1; --Owner TUID is 1 in DB

        --INSERT users into the Access table for the new store
        IF @USER_TUIDS IS NOT NULL AND @USER_TUIDS <> ''
        BEGIN
             BEGIN TRY
                INSERT INTO Access (USER_TUID, STORE_TUID)
                SELECT VALUE, @TUID
                FROM STRING_SPLIT(@USER_TUIDS, ',');
            END TRY
            BEGIN CATCH
                -- If the error is a duplicate key violation (error number 2627)
                IF ERROR_NUMBER() = 2627
                BEGIN
                    SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
                END
            END CATCH;
        END;

        --Return the newly inserted store TUID
        SELECT 'OK 200' AS Response;
    END
    
    --ELSE: the store is updated instead 
	ELSE 
    BEGIN
		-- Update Store size
		IF @WIDTH IS NOT NULL OR @LENGTH IS NOT NULL
		BEGIN
			UPDATE Stores
			SET WIDTH = @WIDTH,
				LENGTH = @LENGTH
			WHERE TUID = @TUID
		END

		-- Update for Public info
		IF @WIDTH IS NULL OR @LENGTH IS NULL
		BEGIN
			UPDATE Stores
			SET NAME = @NAME,
				ADDRESS = @ADDRESS,
				CITY = @CITY,
				STATE = @STATE, 
				ZIP = @ZIP,
				BLUEPRINT_IMAGE = @BLUEPRINT_IMAGE
			WHERE TUID = @TUID;

			--DROP all users from the current store
			DELETE FROM Access
			WHERE STORE_TUID = @TUID;

			--INSERT all owners into Access for the store
			INSERT INTO Access (USER_TUID, STORE_TUID)
			SELECT Users.TUID, @TUID
			FROM Users
			WHERE Users.ROLE_TUID = 1; --Owner TUID is 1 in DB
        
			--INSERT users into the Access table for the store
			IF @USER_TUIDS IS NOT NULL AND @USER_TUIDS <> ''
			BEGIN
				BEGIN TRY
					INSERT INTO Access (USER_TUID, STORE_TUID)
					SELECT VALUE, @TUID
					FROM STRING_SPLIT(@USER_TUIDS, ',') AS SplitUsers
					WHERE NOT EXISTS (
						SELECT 1 FROM Access 
						WHERE Access.USER_TUID = SplitUsers.VALUE 
						AND Access.STORE_TUID = @TUID
					);
				END TRY
				BEGIN CATCH
					-- If the error is a duplicate key violation (error number 2627)
					IF ERROR_NUMBER() = 2627
					BEGIN
						SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
					END
				END CATCH;
			END;
		END

        --Return the updated TUID
        SELECT 'OK 200' AS Response;
    END
END;
GO
