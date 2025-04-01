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

CREATE OR ALTER PROCEDURE [dbo].[Select_Users_NoStore_Access]
(
	@StoreID INT = NULL
)
AS
BEGIN
	IF @StoreID IS NOT NULL
	BEGIN
		SELECT DISTINCT 
			u.TUID, 
			CONCAT(u.FIRST_NAME, ' ', u.LAST_NAME) AS 'Employee Name'
		FROM Users AS u
		JOIN Access AS a ON u.TUID = a.USER_TUID
		JOIN Stores AS s ON s.TUID = a.STORE_TUID
		WHERE NOT EXISTS (
			SELECT 1
			FROM Access AS a2
			WHERE a2.USER_TUID = u.TUID
			AND a2.STORE_TUID = @StoreID
		)
	END
	ELSE
	BEGIN
		SELECT 'Error 500: No StoreID' As Response
	END
END
GO