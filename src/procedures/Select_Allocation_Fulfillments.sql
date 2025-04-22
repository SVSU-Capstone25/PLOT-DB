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
	SELECT 
		sc.TUID,
		sc.NAME AS SUPERCATEGORY_NAME,
		sa.SUBCATEGORY,
		sc.COLOR AS SUPERCATEGORY_COLOR,
		SUM(ff.ALLOCATED_LF) AS CURRENT_LF,
		FLOOR(
			SUM(sa.TOTAL_SALES) * 1.0 /
			(
				SELECT SUM(sa2.TOTAL_SALES)
				FROM Sales_Allocation AS sa2
					JOIN Floorsets_Fixtures AS ff2 
						ON sa2.SUBCATEGORY = ff2.SUBCATEGORY
				WHERE ff2.FLOORSET_TUID = 5
			 )
			*
			(
				SELECT TOTAL_INSTANCE_LF 
				FROM dbo.Get_Total_Floorset_LF(5)
			)
		) AS NEEDED_LF
	FROM Sales_Allocation AS sa 
		JOIN Floorsets_Fixtures AS ff 
			ON sa.SUBCATEGORY = ff.SUBCATEGORY
		JOIN Fixtures AS f 
			ON f.TUID = ff.FIXTURE_TUID
		JOIN Supercategories AS sc 
			ON sc.TUID = sa.SUPERCATEGORY_TUID
	WHERE ff.FLOORSET_TUID = 5
	GROUP BY sc.TUID, sa.SUBCATEGORY, sc.COLOR, sc.NAME;
END
GO