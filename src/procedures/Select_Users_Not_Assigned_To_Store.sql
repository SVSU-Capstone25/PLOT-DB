SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 3/29/2025
-- Description: 
-- This select grabs all the users not assigned to the store
-- And returns a table of all those users.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Users_Not_Assigned_To_Store]
(
	@STORE_TUID INT = NULL
)
AS
BEGIN
	IF @STORE_TUID IS NOT NULL
	BEGIN
		SELECT DISTINCT 
			u.TUID, 
			u.FIRST_NAME,
			u.LAST_NAME,
			u.EMAIL,
			u.ROLE_TUID
		FROM Users AS u
		JOIN Access AS a ON u.TUID = a.USER_TUID
		JOIN Stores AS s ON s.TUID = a.STORE_TUID
		WHERE NOT EXISTS (
			SELECT 1
			FROM Access AS a2
			WHERE a2.USER_TUID = u.TUID
			AND a2.STORE_TUID = @STORE_TUID
		)
	END
	ELSE
	BEGIN
		SELECT 'Error 500: Store not found' As Response
	END
END
GO