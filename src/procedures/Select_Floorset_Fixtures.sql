SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the fixtures in a floorset.
-- Updated: 4/9/2025 - Filters Sales_Allocation to only include unique SUPERCATEGORY_TUIDs
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Floorset_Fixtures]
(
    @FLOORSET_TUID INT = NULL
)
AS
BEGIN
    SELECT 
        Floorsets_Fixtures.TUID, 
        Floorsets_Fixtures.FIXTURE_TUID,
        Floorsets_Fixtures.FLOORSET_TUID, 
        Fixtures.NAME, 
        Fixtures.WIDTH, 
        Fixtures.LENGTH, 
        Floorsets_Fixtures.X_POS,
        Floorsets_Fixtures.Y_POS, 
        Floorsets_Fixtures.HANGER_STACK,
        Floorsets_Fixtures.ALLOCATED_LF, 
        (Floorsets_Fixtures.HANGER_STACK * Fixtures.LF_CAP) AS TOT_LF, 
        Floorsets_Fixtures.NOTE, 
    	Floorsets_Fixtures.SUPERCATEGORY_TUID,
        Floorsets_Fixtures.SUBCATEGORY,
        SuperCategories.NAME AS SUPERCATEGORY_NAME, 
        SuperCategories.COLOR,
        Floorsets_Fixtures.EDITOR_ID,
        Floorsets_Fixtures.FIXTURE_IDENTIFIER
    FROM Floorsets_Fixtures
    JOIN SuperCategories
        ON Floorsets_Fixtures.SUPERCATEGORY_TUID = SuperCategories.TUID
        JOIN Fixtures 
            ON Floorsets_Fixtures.FIXTURE_TUID = Fixtures.TUID
    WHERE Floorsets_Fixtures.FLOORSET_TUID = @FLOORSET_TUID
END
GO