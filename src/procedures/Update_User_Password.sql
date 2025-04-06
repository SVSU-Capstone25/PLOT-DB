/****** Object:  StoredProcedure [dbo].[Update_User_Password]    Script Date: 4/6/2025 3:31:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/6/2025
-- Description:
-- This insert stored procedure is for a user to 
-- update their password.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Update_User_Password]
(
	@EMAIL VARCHAR(320) = NULL,
	@NewPassword VARCHAR(100) = NULL
)
AS
BEGIN
	
	IF @EMAIL IS NOT NULL AND @NewPassword IS NOT NULL
	BEGIN
		-- Checking if the email exists
		IF EXISTS (
			SELECT 1 
			FROM Users
			WHERE EMAIL = @EMAIL
		) 
		BEGIN
			UPDATE Users
			SET PASSWORD = @NewPassword
			WHERE EMAIL = @EMAIL
		END
		ELSE
		BEGIN
			SELECT 'Error 404: Email not found' AS Response
		END
	END
	ELSE
	BEGIN
		SELECT 'Error 500' AS Response
	END
END
GO