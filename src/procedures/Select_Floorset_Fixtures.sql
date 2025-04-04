SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the fixtures in a floorset.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Floorset_Fixtures]
(
	@FloorsetID INT = NULL
)
AS
BEGIN
	SELECT *
	FROM Floorsets_Fixtures
	WHERE FLOORSET_TUID = @FloorsetID
END
GO