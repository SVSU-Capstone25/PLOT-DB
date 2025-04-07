SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================
--	** FUNCTION DESCRIPTION **
-- Created By: Zach Ventimiglia
-- Created Date: 4/7/2025
-- Description: 
-- This function converts a JSON file to a returnable table
-- for allocation the sales data.
-- =========================================================

CREATE OR ALTER FUNCTION [dbo].[Convert_JSON_Allocations](@Input NVARCHAR(MAX))
RETURNS @AllocationData TABLE (
	[SUPERCATEGORY] VARCHAR(100),
	[SUBCATEGORY] VARCHAR(100),
	[TOTAL_SALES] INT
)
AS
BEGIN
	INSERT @AllocationData
	SELECT JSON_VALUE(value, '$.category') AS SUPERCATEGORY,
		JSON_VALUE(value, '$.subCategory') AS SUBCATEGORY,
		CAST(JSON_VALUE(value, '$.units') AS INT) AS TOTAL_SALES
	FROM OPENJSON (@Input)

	RETURN
END
GO