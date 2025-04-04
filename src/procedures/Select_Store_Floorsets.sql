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
	@StoreID INT = NULL
)
AS
BEGIN
	IF @StoreID IS NOT NULL
	BEGIN
		SELECT *
		FROM Floorsets
		WHERE STORE_TUID = @StoreID
	END
	ELSE
	BEGIN
		SELECT 'Error 500' AS Response
	END
END
GO


