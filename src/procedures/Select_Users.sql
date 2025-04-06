SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the users or if the parameter
-- is not null, it'll grab the singular user
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Users]
(
	@USER_TUID INT = NULL
)
AS
BEGIN
	SELECT 
		TUID,
		FIRST_NAME,
		LAST_NAME,
		EMAIL,
		CASE 
			WHEN @USER_TUID IS NOT NULL THEN PASSWORD 
			ELSE NULL 
		END AS PASSWORD,
		ROLE_TUID
	FROM Users
	WHERE TUID = 
	CASE
		WHEN @USER_TUID IS NOT NULL THEN @USER_TUID
		ELSE TUID 
		END;
END
GO