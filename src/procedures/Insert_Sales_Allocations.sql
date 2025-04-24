SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/7/2025
-- Description: 
-- This stored procedure adds allocated information
-- to the sales allocation table
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[Insert_Sales_Allocations]
(
	@SALES_TUID INT,
    @INPUT NVARCHAR(MAX)
)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Sales_Allocation (SUBCATEGORY, TOTAL_SALES, SALES_TUID, SUPERCATEGORY_TUID)
		SELECT
			SUBCATEGORY,
			TOTAL_SALES,
			@SALES_TUID AS SALES_TUID,
			(SELECT TUID
				FROM Supercategories
				WHERE NAME = SUPERCATEGORY
			) AS SUPERCATEGORY_TUID
		FROM [dbo].[Convert_JSON_Allocations](@INPUT)
        SELECT 200 AS Response;
    END TRY
    BEGIN CATCH
        
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END;
GO