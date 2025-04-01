SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- Deletes the store data as well as all the childen
-- data tables associated with that store.
-- =============================================

CREATE   PROCEDURE [dbo].[Delete_Store]
(
    @StoreID INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Check if the Store exists
        IF EXISTS (SELECT 1 FROM Stores WHERE TUID = @StoreID)

        -- Store exists - remove store
        BEGIN
            
			-- Delete floorsets associated to the store
			DELETE FROM Floorsets
			WHERE STORE_TUID = @StoreID;

			-- Delete fixtures associated to the store
			DELETE FROM Fixtures
			WHERE STORE_TUID = @StoreID;

            -- Delete from the access table where user exists
            DELETE FROM Access
            WHERE STORE_TUID = @StoreID;
			
			-- Delete the Store from the table
            DELETE FROM Stores
            WHERE TUID = @StoreID;

            -- Successful response
            SELECT 'OK 200' AS Response;
        END

        ELSE
        -- User does not exist
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