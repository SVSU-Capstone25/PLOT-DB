SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* 
	Filename: Insert_Access.sql

	File Purpose: Add access for a given
	user to a given store.
	
	Written By: Krzysztof Hejno
*/

CREATE OR ALTER PROCEDURE [dbo].[Insert_Access]

	-- User to add access for
	@USER_TUID INT,	
	
	-- Store to add access to
	@STORE_TUID INT
	
AS
BEGIN

	-- If store and user both exist
	IF NOT EXISTS (
		SELECT 1 
		FROM Access 
		WHERE USER_TUID = @USER_TUID AND STORE_TUID = @STORE_TUID
	)

	BEGIN
		BEGIN TRY
			-- add store from access table for that user
			INSERT INTO Access 
			(
				USER_TUID,
				STORE_TUID
			) 
			VALUES 
			(
				@USER_TUID, 
				@STORE_TUID
			)
			
			SELECT 'OK 200' As Response;
		END TRY
		BEGIN CATCH
			-- Handle errors
			SELECT ERROR_MESSAGE() As Response;
		END CATCH
	END

	-- If either store or user does exist
	ELSE
	BEGIN
	    SELECT 'NOT FOUND 500' As Response;
	END
END;
GO


