SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the fixture models in a store.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Fixtures]
(
	@FixtureID INT = NULL
)
AS
BEGIN
	SELECT *
	FROM Fixtures
	WHERE TUID = 
	CASE
		WHEN @FixtureID IS NOT NULL THEN @FixtureID
		ELSE STORE_TUID 
		END;
END
GO