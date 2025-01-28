/*
Filename: fixture_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions for retrieving and managing fixtures in the system.

Written by: Krzysztof Hejno
*/

-- Function: Get Fixture Details by Name
CREATE FUNCTION GetFixtureByName(@FixtureName NVARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT TUID, NAME, WIDTH, HEIGHT, LF_CAP, HANGER_STACK_INT, TOT_LF_DECIMAL, ICON
    FROM fixtures
    WHERE NAME = @FixtureName
);
GO

-- Function: Count Fixtures by Store Name
CREATE FUNCTION CountFixturesByStoreName(@StoreName NVARCHAR(100))
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM fixtures f
            INNER JOIN store s ON f.STORE_TUID = s.TUID
            WHERE s.NAME = @StoreName);
END;
GO

-- Function: Get All Fixtures in a Store by Store Name
CREATE FUNCTION GetFixturesByStoreName(@StoreName NVARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT f.TUID, f.NAME, f.WIDTH, f.HEIGHT, f.LF_CAP, f.HANGER_STACK_INT, f.TOT_LF_DECIMAL, f.ICON
    FROM fixtures f
    INNER JOIN store s ON f.STORE_TUID = s.TUID
    WHERE s.NAME = @StoreName
);
GO

-- Function: Get Fixture Positions in a Layout by Name
CREATE FUNCTION GetFixturePositionsByLayout(@LayoutName NVARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT f.NAME AS FixtureName, lf.X_POS, lf.Y_POS
    FROM layout_fixtures lf
    INNER JOIN layout l ON lf.LAYOUT_TUID = l.TUID
    INNER JOIN fixtures f ON lf.FIXTURE_TUID = f.TUID
    WHERE l.NAME = @LayoutName
);
GO

-- Function: Get Layouts Using a Specific Fixture by Name
CREATE FUNCTION GetLayoutUsingFixture(@FixtureName NVARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT l.TUID, l.NAME, l.DATE_CREATED, l.DATE_MODIFIED
    FROM layout_fixtures ff
    INNER JOIN fixtures f ON ff.FIXTURE_TUID = f.TUID
    INNER JOIN Layout l ON ff.LAYOUT_TUID = l.TUID
    WHERE f.NAME = @FixtureName
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