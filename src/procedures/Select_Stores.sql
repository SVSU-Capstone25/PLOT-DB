SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the stores or if the parameter
-- is not null, it'll grab the singular store
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Stores]
(
	@STORE_TUID INT = NULL
)
AS
BEGIN
	SELECT *
	FROM Stores
	WHERE TUID = 
	CASE
		WHEN @STORE_TUID IS NOT NULL THEN @STORE_TUID
		ELSE TUID 
		END;
END
GO