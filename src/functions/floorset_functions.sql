/*
Filename: floorset_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions pertaining to floorset management and fixtures.

Written by: Krzysztof Hejno
*/

-- Function: Get Fixture Details by floorset
ALTER FUNCTION [dbo].[GetFixturesByFloorset](@floorsetTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT ff.FLOORSET_TUID, f.NAME, f.WIDTH, f.HEIGHT, ff.X_POS, ff.Y_POS, ff.ALLOCATED_LF, ff.CATEGORY, ff.NOTE
    FROM floorsets_fixtures ff
    INNER JOIN fixtures f ON ff.FIXTURE_TUID = f.TUID
    WHERE ff.FLOORSET_TUID = @floorsetTUID
);

-- Function: Count Fixtures in a floorset
CREATE FUNCTION CountFixturesInFloorset(@floorsetTUID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM floorset_fixtures
            WHERE FLOORSET_TUID = @floorsetTUID);
END;
GO

-- Function: Get floorset Details by Store
CREATE FUNCTION GetFloorsetsByStore(@StoreTUID INT)
RETURNS TABLE
AS
BEGIN
RETURN (
    SELECT f.TUID, f.NAME, f.DATE_CREATED, f.DATE_MODIFIED
    FROM floorset f
    WHERE f.STORE_TUID = @StoreTUID
);
END;
GO



-- Function: Get store information for a store based on its name
CREATE FUNCTION [dbo].[GetStoreInfoByName](@StoreName varchar(100))
RETURNS TABLE
AS
RETURN (
    SELECT s.TUID,s.WIDTH,s.HEIGHT,s.ADDRESS,s.BLUEPRINT_IMAGE
    FROM Store s
    WHERE s.NAME = @StoreName
);
GO