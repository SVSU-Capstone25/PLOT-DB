/****** Object:  StoredProcedure [dbo].[Insert_Access]    Script Date: 4/5/2025 8:08:47 PM ******/
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

CREATE PROCEDURE [dbo].[Insert_Access]

	-- User to add access for
	@User_tuid INT,	
	
	-- Store to add access to
	@Store_tuid INT
	
AS
BEGIN

	-- If store and user both exist
	IF NOT EXISTS (SELECT 1 FROM Access WHERE USER_TUID = @User_tuid AND STORE_TUID=@Store_tuid)

	BEGIN
		BEGIN TRY
			-- add store from access table for that user
			INSERT INTO Access (USER_TUID,STORE_TUID) 
			VALUES (@User_tuid,@Store_tuid)
			
			
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


