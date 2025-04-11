SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/4/2025
-- Description: 
-- This select grabs all the floorsets for a store.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Stores_Floorsets]
(
	@STORE_TUID INT = NULL
)
AS
BEGIN
	IF @STORE_TUID IS NOT NULL
	BEGIN
		SELECT *
		FROM Floorsets
		WHERE STORE_TUID = @STORE_TUID
	END
	ELSE
	BEGIN
		SELECT 500 AS Response
	END
END
GO
