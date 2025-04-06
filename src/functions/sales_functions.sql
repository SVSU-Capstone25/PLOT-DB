/*
Filename: sales_functions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions for retrieving sales data related to floorsets and stores.

Written by: Krzysztof Hejno

Update by: Andrew Miller (4/2/2025)

Update Purpose: Had to change other function files to pluralize stores
and take care of supercategories and subcategories.

Abbreviations in some functions were counterintuitive.
Changed to just using table names across function files,
except floorset-fixtures as ff (floorset-fixtures not
in this particular file)
*/

-- Function: Get Sales Data by floorset
CREATE FUNCTION [dbo].[GetSalesDataByFloorset](@FLOORSET_TUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT sales.FILENAME AS FILE_NAME, sales.FILEDATA AS FILE_DATA, sales.CAPTURE_DATE, sales.DATE_UPLOADED
    FROM sales
    WHERE sales.FLOORSET_TUID = @FLOORSET_TUID
);
GO

-- Function: Get Latest Sales Data for a Store
CREATE FUNCTION [dbo].[GetLatestSalesDataByStore](@STORE_TUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (1) sales.FILENAME AS FILE_NAME, sales.FILEDATA AS FILE_DATA,
        sales.CAPTURE_DATE, sales.DATE_UPLOADED
    FROM sales
    INNER JOIN floorsets ON sales.FLOORSET_TUID = floorsets.TUID
    WHERE floorsets.STORE_TUID = @STORE_TUID
    ORDER BY sales.DATE_UPLOADED DESC
);
GO