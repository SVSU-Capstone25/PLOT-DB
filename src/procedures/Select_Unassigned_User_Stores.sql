SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/9/2025
-- Description: 
-- This select grabs all the stores the user is
-- not assigned to.
-- =============================================

CREATE PROCEDURE [dbo].[Select_Unassigned_User_Stores]
(
    @USER_TUID INT = NULL
)
AS
BEGIN
	IF @USER_TUID IS NOT NULL
	BEGIN
		SELECT
			s.TUID,
			s.NAME,
			s.ADDRESS,
			s.CITY,
			s.STATE,
			s.ZIP,
			s.WIDTH,
			s.LENGTH,
			s.BLUEPRINT_IMAGE
		FROM Users u
		CROSS JOIN Stores s
		LEFT JOIN Access a 
			ON u.TUID = a.USER_TUID AND s.TUID = a.STORE_TUID
		WHERE a.USER_TUID IS NULL AND u.TUID = @USER_TUID
	END
	ELSE
	BEGIN
		SELECT 'Error 500' AS Response
	END
END
GO