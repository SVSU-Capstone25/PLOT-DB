/*
Filename: sales_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions for retrieving sales data related to floorsets and stores.

Written by: Krzysztof Hejno
*/

-- Function: Get Sales Data by floorset
CREATE FUNCTION [dbo].[GetSalesDataByFloorset](@floorsetTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT sd.FILENAME, sd.FILEDATA, sd.CAPTURE_DATE, sd.DATE_UPLOADED
    FROM Sales sd
    WHERE sd.FLOORSET_TUID = @floorsetTUID
);
GO


-- Function: Get Latest Sales Data for a Store
CREATE FUNCTION [dbo].[GetLatestSalesDataByStore](@StoreTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (1) sd.FILENAME, sd.FILEDATA, sd.CAPTURE_DATE, sd.DATE_UPLOADED
    FROM Sales sd
    INNER JOIN floorsets f ON sd.FLOORSET_TUID = f.TUID
    WHERE f.STORE_TUID = @StoreTUID
    ORDER BY sd.DATE_UPLOADED DESC
);
GO