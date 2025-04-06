SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the users assigned to a store
-- using the store id
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Store_Users]
(
	@StoreID INT = NULL
)
AS
BEGIN
	IF @StoreID IS NOT NULL
	BEGIN
		SELECT 
			u.TUID,
			u.FIRST_NAME,
			u.LAST_NAME,
			u.ROLE_TUID
		FROM Stores AS s JOIN Access AS a 
				ON s.TUID = a.STORE_TUID
			JOIN Users AS u 
				ON u.TUID = a.USER_TUID
		WHERE s.TUID = @StoreID
	END
	ELSE
	BEGIN
		SELECT 'Error 500: User not found' AS Response
	END
END
GO