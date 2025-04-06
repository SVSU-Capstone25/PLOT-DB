SET ANSI_NULLS ON
GO

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
	@FIXTURE_TUID INT = NULL
)
AS
BEGIN
	SELECT *
	FROM Fixtures
	WHERE TUID = 
	CASE
		WHEN @FIXTURE_TUID IS NOT NULL THEN @FIXTURE_TUID
		ELSE TUID 
		END;
END
GO