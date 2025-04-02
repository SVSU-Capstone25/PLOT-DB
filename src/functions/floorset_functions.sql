/*
Filename: floorset_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions pertaining to floorset management and fixtures.

Written by: Krzysztof Hejno

Update by: Andrew Miller (4/2/2025)
Update Purpose: Handling supercategories table and including this information
in fixture details.

Abbreviations in some functions were counterintuitive.
Changed to just using table names across function files,
except floorset-fixtures as ff.
*/

-- Function: Get Fixture Details by floorset
-- Returns Fields:
--      FLOORSET_TUID, NAME,
--      WIDTH, HEIGHT,
--      X_POS, Y_POS,
--      ALLOCATED_LF,
--      SUPERCATEGORY,
--      SUBCATEGORY,
--      COLOR,
--      NOTE
CREATE FUNCTION [dbo].[GetFixturesByFloorset](@floorsetTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT ff.FLOORSET_TUID, fixtures.NAME,
    fixtures.WIDTH, fixtures.HEIGHT,
    ff.X_POS, ff.Y_POS,
    ff.ALLOCATED_LF,
    supercategories.NAME SUPERCATEGORY,
    ff.SUBCATEGORY,
    supercategories.COLOR,
    ff.NOTE
    FROM floorsets_fixtures ff
    INNER JOIN fixtures ON
        ff.FIXTURE_TUID = fixtures.TUID
    INNER JOIN supercategories ON
        supercategories.TUID = ff.SUPERCATEGORY_TUID
     WHERE ff.FLOORSET_TUID = @floorsetTUID

);
GO

-- Function: Count Fixtures in a floorset
CREATE FUNCTION [dbo].[CountFixturesInFloorset](@floorsetTUID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM floorsets_fixtures
            WHERE FLOORSET_TUID = @floorsetTUID);
END;
GO

-- Function: Get floorset Details by Store
-- Returns fields: TUID, Name, Date_Created, Date_Modified
CREATE FUNCTION [dbo].[GetFloorsetsByStore](@StoreTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT floorsets.TUID, floorsets.NAME,
        floorsets.DATE_CREATED, floorsets.DATE_MODIFIED
    FROM floorsets
    WHERE floorsets.STORE_TUID = @StoreTUID
);
GO

-- Function: Get store information for a store based on its name
-- Returns fields: TUID, Width, Height, Address, Blueprint_Image
CREATE FUNCTION [dbo].[GetStoreInfoByName](@StoreName varchar(100))
RETURNS TABLE
AS
RETURN (
    SELECT stores.TUID,stores.WIDTH,stores.HEIGHT,
        stores.ADDRESS,stores.BLUEPRINT_IMAGE
    FROM stores
    WHERE stores.NAME = @StoreName
);
GO