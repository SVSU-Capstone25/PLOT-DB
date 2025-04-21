SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Clayton Cook    
-- Create Date: 4/19/2025
-- TODO: Description: 
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Users_By_String]
(
	@TUIDS VARCHAR(MAX)
)
AS
BEGIN
	IF @TUIDS <> ''
	BEGIN
		SELECT TUID, 
			FIRST_NAME,
			LAST_NAME,
			EMAIL,
			(
				SELECT NAME 
				FROM Roles 
				WHERE TUID = ROLE_TUID
			) AS 'ROLE'
		FROM Users
			JOIN STRING_SPLIT(@TUIDS, ',') AS split
    		ON Users.TUID = CAST(split.VALUE AS INT)
	END
END
GO