/* 
	Filename: proc_revoke_store_access.sql

	File Purpose: Revoke access for a given
	user to a given store.
	
	Written By: Andrew Miller
*/

CREATE PROCEDURE revoke_store_access

	-- User to revoke access for
	@User_tuid INT,	
	
	-- Store to revoke access to
	@Store_tuid INT,
	
	-- Message indicating procedure success or failure
	@result_message NVARCHAR(255) OUTPUT
AS
BEGIN

	-- If store and user both exist
	IF EXISTS (SELECT 1 FROM Users WHERE TUID = @User_tuid)
	AND 
	EXISTS (SELECT 1 FROM Stores WHERE TUID = @Store_tuid)

	BEGIN
		BEGIN TRY
			-- Delete store from access table for that user
			DELETE FROM access
			WHERE USER_TUID = @User_tuid AND STORE_TUID = @Store_tuid
			
			SET @result_message = 'OK 200';
		END TRY
		BEGIN CATCH
			-- Handle errors
			SET @result_message = ERROR_MESSAGE();
		END CATCH
	END

	-- If either store or user does NOT exist
	ELSE
	BEGIN
	    SET @result_message = 'NOT FOUND 500';
	END
END;
GO
