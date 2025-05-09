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

Changed references to "height" to "length"
*/

-- Function: Get Fixture Details by floorset
-- Returns Fields:
--      FLOORSET_TUID, NAME,
--      WIDTH, LENGTH,
--      X_POS, Y_POS,
--      SUPERCATEGORY,
--      SUBCATEGORY,
--      COLOR,
--      NOTE
CREATE FUNCTION [dbo].[GetFixturesByFloorset](@FLOORSET_TUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT ff.FLOORSET_TUID, fixtures.NAME,
    fixtures.WIDTH, fixtures.LENGTH,
    ff.X_POS, ff.Y_POS,
    supercategories.NAME SUPERCATEGORY,
    ff.SUBCATEGORY,
    supercategories.COLOR,
    ff.NOTE
    FROM floorsets_fixtures ff
    INNER JOIN fixtures ON
        ff.FIXTURE_TUID = fixtures.TUID
    INNER JOIN supercategories ON
        supercategories.TUID = ff.SUPERCATEGORY_TUID
     WHERE ff.FLOORSET_TUID = @FLOORSET_TUID

);
GO

-- Function: Count Fixtures in a floorset
CREATE FUNCTION [dbo].[CountFixturesInFloorset](@FLOORSET_TUID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM floorsets_fixtures
            WHERE FLOORSET_TUID = @FLOORSET_TUID);
END;
GO

-- Function: Get floorset Details by Store
-- Returns fields: TUID, Name, Date_Created, Date_Modified
CREATE FUNCTION [dbo].[GetFloorsetsByStore](@STORE_TUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT floorsets.TUID, floorsets.NAME,
        floorsets.DATE_CREATED, floorsets.DATE_MODIFIED
    FROM floorsets
    WHERE floorsets.STORE_TUID = @STORE_TUID
);
GO

-- Function: Get store information for a store based on its name
-- Returns fields: TUID, Width, Length, Address, Blueprint_Image
CREATE FUNCTION [dbo].[GetStoreInfoByName](@STORE_NAME varchar(100))
RETURNS TABLE
AS
RETURN (
    SELECT stores.TUID,stores.WIDTH,stores.Length,
        stores.ADDRESS,stores.BLUEPRINT_IMAGE
    FROM stores
    WHERE stores.NAME = @STORE_NAME
);
GO