SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/14/2025
-- Description: 
-- This SP deletes an employee area instance
-- ===============================================
CREATE PROCEDURE [dbo].[Delete_Employee_Area]
	@FLOORSET_TUID INT,
	@X_POS INT,
	@Y_POS INT
AS
BEGIN
	
	BEGIN TRY
		-- See if the allocation exists
		IF EXISTS (
			SELECT 1 
			FROM Employee_Area
			WHERE FLOORSET_TUID = @FLOORSET_TUID AND
				X_POS = @X_POS AND Y_POS = @Y_POS
		)
		BEGIN
			DELETE FROM Employee_Area
			WHERE FLOORSET_TUID = @FLOORSET_TUID AND
				X_POS = @X_POS AND Y_POS = @Y_POS

			SELECT 200 AS Response
		END
		ELSE
		BEGIN
            -- Failed response
            SELECT 'NOT FOUND 404' As Response;
        END;
		
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS Response
	END CATCH

END
GO