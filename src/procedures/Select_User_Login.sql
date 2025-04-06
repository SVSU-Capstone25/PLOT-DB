SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/6/2025
-- Description: 
-- This select proc will be used to authenticate
-- a user on login
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_User_Login]
(
	@Email VARCHAR(320) = NULL
)
AS
BEGIN
	IF @Email IS NOT NULL
	BEGIN
		SELECT 
			TUID,
			FIRST_NAME,
			LAST_NAME,
			EMAIL,
			PASSWORD,
			(
				SELECT NAME 
				FROM Roles 
				WHERE TUID = ROLE_TUID
			) AS 'ROLE',
			ACTIVE
		FROM Users
		WHERE EMAIL = @EMAIL
	END
	ELSE
	BEGIN
		SELECT 'Error 500' AS Response
	END
END
GO