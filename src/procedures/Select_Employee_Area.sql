SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/14/2025
-- Description: 
-- This SP selects all employees areas for a floorset
-- ===============================================
CREATE PROCEDURE [dbo].[Select_Employee_Area]
	@FLOORSET_TUID INT
AS
BEGIN
	BEGIN TRY
		-- Seeing if that floorset exists
		IF EXISTS (
			SELECT 1
			FROM Floorsets
			WHERE TUID = @FLOORSET_TUID
		)
		BEGIN
			SELECT *
			FROM Employee_Area
			WHERE FLOORSET_TUID = @FLOORSET_TUID
		END
		ELSE
		BEGIN
			SELECT 'Error 404: Not Found' AS Response
		END

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS Response
	END CATCH
END
GO