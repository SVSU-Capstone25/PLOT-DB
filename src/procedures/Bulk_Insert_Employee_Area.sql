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
-- Updated By: Zach Ventimiglia
-- Updated Date: 4/23/2025
-- Description:
-- Set it so it the painted employee area is out of scope
-- it will not insert those rows, but will insert the ones
-- within the scope.
-- ===============================================
CREATE OR ALTER PROCEDURE [dbo].[Bulk_Insert_Employee_Area]
	@FLOORSET_TUID INT,
	@X1_POS INT,
	@Y1_POS INT,
	@X2_POS INT,
	@Y2_POS INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @WIDTH INT, @LENGTH INT;

		-- Lookup store dimensions from Floorset
		SELECT 
			@WIDTH = S.WIDTH, 
			@LENGTH = S.LENGTH
		FROM Floorsets F
		JOIN Stores S ON F.STORE_TUID = S.TUID
		WHERE F.TUID = @FLOORSET_TUID;

		DECLARE @X INT = @X1_POS;
		DECLARE @Y INT;

		WHILE @X < @X2_POS
		BEGIN
			SET @Y = @Y1_POS;

			WHILE @Y < @Y2_POS
			BEGIN
				-- Only insert if within bounds
				IF @X >= 0 AND @Y >= 0 AND @X < @LENGTH AND @Y < @WIDTH
				BEGIN
					INSERT INTO Employee_Area (FLOORSET_TUID, X_POS, Y_POS)
					VALUES (@FLOORSET_TUID, @X, @Y);
				END

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