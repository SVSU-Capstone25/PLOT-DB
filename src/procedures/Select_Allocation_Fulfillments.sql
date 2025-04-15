SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Clayton COok      
-- Create Date: 4/14/2025
-- Description: 
-- This select grabs all the allocation details for the allocations sidebar.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Allocation_Fulfillments]
(
	@FLOORSET_TUID INT
)
AS
BEGIN
	SELECT 
        SA.SUPERCATEGORY_TUID,
        SA.SUBCATEGORY,
        SC.COLOR AS SUPERCATEGORY_COLOR,
        SC.NAME AS SUPERCATEGORY_NAME,
        SA.TOTAL_SALES
    FROM Sales AS S
        JOIN Sales_Allocation as SA ON SA.SALES_TUID = S.TUID
        JOIN Supercategories as SC ON SC.TUID = SA.SUPERCATEGORY_TUID
    WHERE S.FLOORSET_TUID = @FLOORSET_TUID
END
GO