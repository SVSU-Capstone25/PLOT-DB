SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This stored procedure deletes a floorset, it will
-- also remove the sales data connected to said floorset.
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[Delete_Floorset]
(
    @FLOORSET_TUID INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Check if the floorset exists
        IF EXISTS (
            SELECT 1 
                FROM Floorsets
                WHERE TUID = @FLOORSET_TUID
            )

        -- Floorset exists - remove floorset
        BEGIN
			-- Delete the sales data from the table
            DELETE FROM Sales
            WHERE FLOORSET_TUID = @FLOORSET_TUID;

			-- Delete floorsets associated to the store
			DELETE FROM Floorsets
			WHERE TUID = @FLOORSET_TUID;

            -- Successful response
            SELECT 200 AS Response;
        END

        ELSE
        -- Floorset does not exist
        BEGIN
            -- Failed response
            SELECT 'NOT FOUND 404' As Response;
        END;

    END TRY

    BEGIN CATCH
        -- Error
        SELECT ERROR_MESSAGE() As Response;
    END CATCH

END;
GO