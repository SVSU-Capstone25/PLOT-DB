SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:      Zach Ventimiglia
-- Create Date: 4/22/2025
-- Description: 
-- This combines the insert sales file stored procedure
-- and the insert sales allocations.
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Sales_With_Allocations]
(
    @FILE_NAME VARCHAR(100) = NULL,
    @FILE_DATA VARBINARY(MAX) = NULL,
    @CAPTURE_DATE DATETIME = NULL,
    @DATE_UPLOADED DATETIME = NULL,
    @FLOORSET_TUID INT = NULL,
    @INPUT NVARCHAR(MAX)  -- JSON string for allocations
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert into Sales
        INSERT INTO Sales
        (
            FILENAME,
            FILEDATA,
            CAPTURE_DATE,
            DATE_UPLOADED,
            FLOORSET_TUID
        ) 
        VALUES 
        (
            @FILE_NAME,
            @FILE_DATA,
            @CAPTURE_DATE,
            @DATE_UPLOADED,
            @FLOORSET_TUID
        );

        -- Get the new Sales TUID
        DECLARE @SALES_TUID INT = SCOPE_IDENTITY();

        -- Insert into Sales_Allocation using parsed JSON
        INSERT INTO Sales_Allocation (SUBCATEGORY, TOTAL_SALES, SALES_TUID, SUPERCATEGORY_TUID)
        SELECT
            SUBCATEGORY,
            TOTAL_SALES,
            @SALES_TUID,
            (SELECT TUID
             FROM Supercategories
             WHERE NAME = SUPERCATEGORY) AS SUPERCATEGORY_TUID
        FROM [dbo].[Convert_JSON_Allocations](@INPUT);

        COMMIT TRANSACTION;
        SELECT 200 AS Response;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END;
GO