SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/14/2025
-- Description: 
-- This SP inserts an employee area instance for a floorset
-- ===============================================
CREATE OR ALTER PROCEDURE [dbo].[Insert_Employee_Area]
	@FLOORSET_TUID INT = NULL,
	@X_POS INT = NULL,
	@Y_POS INT = NULL
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		INSERT INTO Employee_Area
		(
			FLOORSET_TUID,
			X_POS,
			Y_POS
		)
		VALUES
		(
			@FLOORSET_TUID,
			@X_POS,
			@Y_POS
		)
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS Response;
	END CATCH

END
GO