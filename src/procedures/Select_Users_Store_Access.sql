SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the users store access
-- with the store information.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Users_Store_Access]
(
	@UserID INT = NULL
)
AS
BEGIN
	IF @UserID IS NOT NULL
	BEGIN
		SELECT 
			TUID,
			NAME,
			ADDRESS,
			CITY,
			STATE,
			ZIP,
			WIDTH,
			LENGTH,
			BLUEPRINT_IMAGE
		FROM Access AS a JOIN Stores AS s 
			ON a.STORE_TUID = s.TUID
		WHERE a.USER_TUID = @UserID
	END
	ELSE
	BEGIN
		SELECT 'Error 500: User not found' AS Response
	END
END
GO