SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* 
	Filename: Delete_Access.sql

	File Purpose: Revoke access for a given
	user to a given store.
	
	Written By: Andrew Miller
*/

CREATE PROCEDURE [dbo].[Delete_Access]

	-- User to revoke access for
	@User_tuid INT,	
	
	-- Store to revoke access to
	@Store_tuid INT
	
AS
BEGIN

	-- If store and user both exist
	IF EXISTS (SELECT 1 FROM Users WHERE TUID = @User_tuid)
	AND 
	EXISTS (SELECT 1 FROM Store WHERE TUID = @Store_tuid)

	BEGIN
		BEGIN TRY
			-- Delete store from access table for that user
			DELETE FROM access
			WHERE USER_TUID = @User_tuid AND STORE_TUID = @Store_tuid
			
			SELECT 'OK 200' As Response;
		END TRY
		BEGIN CATCH
			-- Handle errors
			SELECT ERROR_MESSAGE() As Response;
		END CATCH
	END

	-- If either store or user does NOT exist
	ELSE
	BEGIN
	    SELECT 'NOT FOUND 404' As Response;
	END
END;
GO