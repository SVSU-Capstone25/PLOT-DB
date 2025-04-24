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
-- Update By: Zach Ventimiglia
-- Update Date: 4/22/2025
-- Description: 
-- Removed old select, made one that returns current allocated LF
-- with the needed LF returned with it. It will also help set the
-- entire allocation sidebar for a specific floorset.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Allocation_Fulfillments]
(
	@FLOORSET_TUID INT
)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
        sc.TUID,
        sc.NAME AS SUPERCATEGORY_NAME,
        sa.SUBCATEGORY,
        sc.COLOR AS SUPERCATEGORY_COLOR,
        ISNULL(SUM(f.LF_CAP * ff.HANGER_STACK), 0) AS CURRENT_LF,
        SUM(sa.TOTAL_SALES) AS TOTAL_SALES,
        (
            SELECT TOTAL_INSTANCE_LF 
                FROM dbo.Get_Total_Floorset_LF(@FLOORSET_TUID)
        ) AS TOTAL_FLOORSET_LF
    FROM Sales_Allocation AS sa
    LEFT JOIN Floorsets_Fixtures AS ff 
        ON sa.SUBCATEGORY = ff.SUBCATEGORY 
    	AND ff.FLOORSET_TUID = @FLOORSET_TUID
    	AND ff.SUPERCATEGORY_TUID = sa.SUPERCATEGORY_TUID
    LEFT JOIN Fixtures AS f 
        ON f.TUID = ff.FIXTURE_TUID
    JOIN Supercategories AS sc 
        ON sc.TUID = sa.SUPERCATEGORY_TUID
    WHERE sa.SALES_TUID IN (
        SELECT TUID FROM Sales WHERE FLOORSET_TUID = @FLOORSET_TUID
    )
    GROUP BY sc.TUID, sa.SUBCATEGORY, sc.COLOR, sc.NAME
    ORDER BY sc.TUID DESC;
END
GO