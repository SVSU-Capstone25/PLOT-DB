SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Andrew Miller      
-- Create Date: 4/15/2025
-- Description: 
-- This select grabs the user by email
-- Assumes email is unique
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_User_By_Email]
(
	@EMAIL VARCHAR(320) = NULL
)
AS
BEGIN
	SELECT 
		TUID,
		FIRST_NAME,
		LAST_NAME,
		EMAIL,
		(
			SELECT NAME 
			FROM Roles 
			WHERE TUID = ROLE_TUID
		) AS [ROLE]
	FROM Users
	WHERE EMAIL = @EMAIL AND ACTIVE = 1
END
GO