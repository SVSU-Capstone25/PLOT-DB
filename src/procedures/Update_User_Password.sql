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
	@Email VARCHAR(320) = NULL,
	@NewPassword VARCHAR(100) = NULL
)
AS
BEGIN
	IF @Email IS NOT NULL AND @NewPassword IS NOT NULL
	BEGIN
		UPDATE Users
		SET PASSWORD = @NewPassword
		WHERE EMAIL = @Email
	END
	ELSE
	BEGIN
		SELECT 'Error 500' AS Response
	END
END
GO