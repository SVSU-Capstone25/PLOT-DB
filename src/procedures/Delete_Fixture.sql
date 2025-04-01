SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This stored procedure deletes a fixture.
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[Delete_Fixture]
(
    @FixtureID INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Check if the floorset fixture exists
        IF EXISTS (
            SELECT 1 
                FROM Fixtures
                WHERE TUID = @FixtureID
            )

        -- Floorset Fixture exists - remove floorset
        BEGIN

			-- Delete floorsets fixture associated to the store
			DELETE FROM Fixtures
			WHERE TUID = @FixtureID;

            -- Successful response
            SELECT 'OK 200' AS Response;
        END

        ELSE
        -- Floorset Fixture does not exist
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