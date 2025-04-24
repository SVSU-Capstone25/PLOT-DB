SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Andrew Miller      
-- Create Date: 4/23/2025
-- Description: 
-- This select proc will be used to get data from
-- the sales data based on Floorset TUID
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Sales_By_Floorset]
(
	@FLOORSET_TUID int
)
AS
BEGIN
	SELECT
		FILENAME AS FILE_NAME,
		FILEDATA AS FILE_DATA,
		CAPTURE_DATE,
		DATE_UPLOADED,
		FLOORSET_TUID
	FROM Sales
	WHERE FLOORSET_TUID = @FLOORSET_TUID
END
GO