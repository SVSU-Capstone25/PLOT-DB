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
CREATE OR ALTER PROCEDURE [dbo].[Bulk_Insert_Employee_Area]
	@FLOORSET_TUID INT,
	@X1_POS INT,
	@Y1_POS INT,
	@X2_POS INT,
	@Y2_POS INT
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @X INT = @X1_POS;
		DECLARE @Y INT;

		WHILE @X < @X2_POS
		BEGIN
			SET @Y = @Y1_POS;
			
			WHILE @Y < @Y2_POS
			BEGIN
				INSERT INTO Employee_Area (FLOORSET_TUID, X_POS, Y_POS)
				VALUES (@FLOORSET_TUID, @X, @Y);

				SET @Y += 1;
			END

			SET @X += 1;
		END
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS Response;
	END CATCH

END
GO