SET ANSI_NULLS ON
GO

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
    @FLOORSET_TUID INT = NULL
)
AS
BEGIN
    SELECT 
        Floorsets_Fixtures.TUID, 
        Floorsets_Fixtures.FLOORSET_TUID, 
        Fixtures.NAME, 
        Fixtures.WIDTH, 
        Fixtures.LENGTH, 
        Floorsets_Fixtures.X_POS,
        Floorsets_Fixtures.Y_POS, 
        Floorsets_Fixtures.HANGER_STACK, 
        Floorsets_Fixtures.ALLOCATED_LF, 
        Floorsets_Fixtures.TOT_LF, 
        Floorsets_Fixtures.NOTE, 
        SuperCategories.NAME As 'SUPERCATEGORY_NAME', 
        Sales_Allocation.SUBCATEGORY, 
        Sales_Allocation.TOTAL_SALES, 
        SuperCategories.COLOR,
        Floorsets_Fixtures.EDITOR_ID
    FROM Floorsets_Fixtures 
        JOIN Fixtures 
            ON Floorsets_Fixtures.FIXTURE_TUID = Fixtures.TUID
        JOIN Sales_Allocation
            ON Floorsets_Fixtures.SUPERCATEGORY_TUID = Sales_Allocation.SUPERCATEGORY_TUID
        JOIN SuperCategories
            ON Sales_Allocation.SUPERCATEGORY_TUID = SuperCategories.TUID
    WHERE Floorsets_Fixtures.FLOORSET_TUID = @FLOORSET_TUID
END
GO