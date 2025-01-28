/*
Filename: sales_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions for retrieving sales data related to layouts and stores.

Written by: Krzysztof Hejno
*/

-- Function: Get Sales Data by Layout
CREATE FUNCTION GetSalesDataByFLayout(@LayoutTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT sd.FILENAME, sd.FILEPATH, sd.CAPTURE_DATE, sd.DATE_UPLOADED
    FROM sales_data sd
    WHERE sd.LAYOUT_TUID = @LayoutTUID
);
GO

-- Function: Get Latest Sales Data for a Store
CREATE FUNCTION GetLatestSalesDataByStore(@StoreTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT sd.FILENAME, sd.FILEPATH, sd.CAPTURE_DATE, sd.DATE_UPLOADED
    FROM sales_data sd
    INNER JOIN Layout f ON sd.LAYOUT_TUID = f.TUID
    WHERE f.STORE_TUID = @StoreTUID
    ORDER BY sd.DATE_UPLOADED DESC
    LIMIT 1
);
GO