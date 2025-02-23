/*
Filename: fixture_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions for retrieving and managing fixtures in the system.

Written by: Krzysztof Hejno
*/

-- Function: Get Fixture Details by Name
CREATE FUNCTION GetFixturesByName(@FixtureName NVARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT TUID, NAME, WIDTH, HEIGHT, LF_CAP, HANGER_STACK_INT, TOT_LF_DECIMAL, ICON
    FROM fixtures
    WHERE NAME = @FixtureName
);
GO

-- Function: Count Fixtures by Store Name
CREATE FUNCTION CountFixturesByStore (@StoreID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM fixtures f
            INNER JOIN store s ON f.STORE_TUID = s.TUID
            WHERE s.TUID= @StoreID);
END;
GO

-- Function: Get All Fixtures in a Store by Store ID
CREATE FUNCTION GetFixturesByStore (@StoreTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT f.TUID, f.NAME, f.WIDTH, f.HEIGHT, f.LF_CAP, f.HANGER_STACK, f.TOT_LF, f.ICON
    FROM fixtures f
    INNER JOIN store s ON f.STORE_TUID = s.TUID
    WHERE s.TUID = @StoreTUID
);
GO

-- Function: Get Fixture Positions in a floorset by ID
CREATE FUNCTION GetFixturePositionsByFloorset (@floorsetID INT)
RETURNS TABLE
AS
RETURN (
    SELECT f.NAME AS FixtureName, lf.X_POS, lf.Y_POS
    FROM floorsets_fixtures lf
    INNER JOIN floorsets fl ON lf.FLOORSET_TUID = fl.TUID
    INNER JOIN fixtures f ON lf.FIXTURE_TUID = f.TUID
    WHERE fl.TUID = @floorsetID
);
GO

-- Function: Get floorsets Using a Specific Fixture by ID
CREATE FUNCTION GetFloorsetsUsingFixture (@FixtureID INT)
RETURNS TABLE
AS
RETURN (
    SELECT fl.TUID, fl.NAME, fl.DATE_CREATED, fl.DATE_MODIFIED
    FROM floorsets_fixtures ff
    INNER JOIN fixtures f ON ff.FIXTURE_TUID = f.TUID
    INNER JOIN floorsets fl ON ff.FLOORSET_TUID = fl.TUID
    WHERE f.NAME = @FixtureID
);
GO

-- Function: Get Fixtures within Dimension Range
CREATE FUNCTION GetFixturesByDimensions(@MinWidth INT, @MaxWidth INT, @MinHeight INT, @MaxHeight INT)
RETURNS TABLE
AS
RETURN (
    SELECT TUID, NAME, WIDTH, HEIGHT, LF_CAP, HANGER_STACK_INT, TOT_LF_DECIMAL, ICON
    FROM fixtures
    WHERE WIDTH BETWEEN @MinWidth AND @MaxWidth
      AND HEIGHT BETWEEN @MinHeight AND @MaxHeight
);
GO