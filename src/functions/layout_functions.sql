/*
Filename: layout_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions pertaining to layout management and fixtures.

Written by: Krzysztof Hejno
*/

-- Function: Get Fixture Details by layout
CREATE FUNCTION GetFixturesBylayout(@LayoutTUID INT)
RETURNS TABLE
AS
BEGIN
RETURN (
    SELECT ff.LAYOUT_TUID, f.NAME, f.WIDTH, f.HEIGHT, ff.X_POS, ff.Y_POS
    FROM layout_fixtures lf
    INNER JOIN fixtures f ON ff.FIXTURE_TUID = f.TUID
    WHERE lf.LAYOUT_TUID = @LayoutTUID
);
END;
GO

-- Function: Count Fixtures in a layout
CREATE FUNCTION CountFixturesInlayout(@LayoutTUID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM layout_fixtures
            WHERE LAYOUT_TUID = @LayoutTUID);
END;
GO

-- Function: Get layout Details by Store
CREATE FUNCTION GetlayoutsByStore(@StoreTUID INT)
RETURNS TABLE
AS
BEGIN
RETURN (
    SELECT f.TUID, f.NAME, f.DATE_CREATED, f.DATE_MODIFIED
    FROM layout f
    WHERE f.STORE_TUID = @StoreTUID
);
END;
GO