SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the floorsets or if the parameter
-- is not null, it'll grab the singular floorset
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Floorsets]
(
	@FLOORSET_TUID INT = NULL
)
AS
BEGIN
	SELECT *
	FROM Floorsets
	WHERE TUID = 
	CASE
		WHEN @FLOORSET_TUID IS NOT NULL THEN @FLOORSET_TUID
		ELSE TUID 
		END;
END
GO