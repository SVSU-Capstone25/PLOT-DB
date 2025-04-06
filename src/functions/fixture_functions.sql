/*
Filename: fixture_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions for retrieving and managing fixtures in the system.

Written by: Krzysztof Hejno

Update by: Andrew Miller (4/2/2025)
Update Purpose: Pluralized store to stores.

Abbreviations in some functions were counterintuitive.
Changed to just using table names across function files,
except floorset-fixtures as ff

Changed references to "height" to "length"
*/

-- Function: Get All Fixtures by fixture Name
-- Returned fields: TUID, NAME, WIDTH, LENGTH, LF_CAP, ICON, STORE_TUID
CREATE FUNCTION [dbo].[GetFixturesByName](@FIXTURE_NAME NVARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT TUID, NAME, WIDTH, LENGTH, LF_CAP, ICON, STORE_TUID
    FROM fixtures
    WHERE NAME = @FIXTURE_NAME
);
GO

-- Function: Count Fixtures by Store Name
CREATE FUNCTION [dbo].[CountFixturesByStore](@STORE_TUID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM fixtures
            INNER JOIN stores 
                ON fixtures.STORE_TUID = stores.TUID
            WHERE stores.TUID= @STORE_TUID);
END;
GO

-- Function: Get All Fixtures in a Store by Store ID
-- Returned fields: TUID, Name, Width, Length, LF_Cap, Icon
CREATE FUNCTION [dbo].[GetFixturesByStore](@STORE_TUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT fixtures.TUID, fixtures.NAME, fixtures.WIDTH,
            fixtures.LENGTH, fixtures.LF_CAP, fixtures.ICON
    FROM fixtures
    INNER JOIN stores ON fixtures.STORE_TUID = stores.TUID
    WHERE stores.TUID = @STORE_TUID
);
GO

-- Function: Get Fixture Positions in a floorset by ID
-- Returned field names: Name, X_POS, Y_POS
CREATE FUNCTION [dbo].[GetFixturePositionsByFloorset](@FLOORSET_TUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT fixtures.NAME AS FIXTURE_NAME,
    ff.X_POS, ff.Y_POS
    FROM floorsets_fixtures ff
    INNER JOIN floorsets ON
        ff.FLOORSET_TUID = floorsets.TUID
    INNER JOIN fixtures ON
        ff.FIXTURE_TUID = fixtures.TUID
    WHERE floorsets.TUID = @FLOORSET_TUID
);
GO

-- Function: Get floorsets Using a Specific Fixture by ID
-- Returned fields: TUID, NAME, DATE_CREATED, DATE_MODIFIED
CREATE FUNCTION [dbo].[GetFloorsetsUsingFixture](@FIXTURE_TUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT floorsets.TUID, floorsets.NAME,
        floorsets.DATE_CREATED, floorsets.DATE_MODIFIED
    FROM floorsets_fixtures ff
    INNER JOIN fixtures ON
        ff.FIXTURE_TUID = fixtures.TUID
    INNER JOIN floorsets ON
        ff.FLOORSET_TUID = floorsets.TUID
    WHERE fixtures.NAME = @FIXTURE_TUID
);
GO

-- Function: Get Fixtures within Dimension Range
-- Returned fields: TUID, Name, Width, Length, LF_Cap, Icon, Store_TUID
CREATE FUNCTION [dbo].[GetFixturesByDimensions](@MIN_WIDTH INT, @MAX_WIDTH INT, @MIN_LENGTH INT, @MAX_LENGTH INT)
RETURNS TABLE
AS
RETURN (
    SELECT TUID, NAME, WIDTH, LENGTH, LF_CAP, ICON, STORE_TUID
    FROM fixtures
    WHERE WIDTH BETWEEN @MIN_WIDTH AND @MAX_WIDTH
      AND LENGTH BETWEEN @MIN_LENGTH AND @MAX_LENGTH
);
GO