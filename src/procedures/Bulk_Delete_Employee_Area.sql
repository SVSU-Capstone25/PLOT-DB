SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================
-- Author: Clayton COok      
-- Create Date: 4/19/2025
-- Description: 
-- TODO: Write documentation
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[Bulk_Delete_Employee_Area]
	@FLOORSET_TUID INT,
	@X1_POS INT,
	@Y1_POS INT,
	@X2_POS INT,
	@Y2_POS INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @X INT = @X1_POS;
		DECLARE @Y INT;

		WHILE @X < @X2_POS
		BEGIN
			SET @Y = @Y1_POS;

			WHILE @Y < @Y2_POS
			BEGIN
				DELETE FROM Employee_Area
				WHERE FLOORSET_TUID = @FLOORSET_TUID
				  AND X_POS = @X
				  AND Y_POS = @Y;

				SET @Y += 1;
			END

			SET @X += 1;
		END
	END TRY
	BEGIN CATCH
		SELECT 
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
