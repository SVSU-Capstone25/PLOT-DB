SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 2/13/2025
-- Description: 
-- This Procedure inserts or updates a row to the Floorsets_Fixtures table
-- by using the TUID and if its null, it inserts a row. Else it will update the row manipulated.
-- =============================================
-- Updated by: Andrew Miller
-- Update Date: 4/2/2025
-- Description: Added Supercategory_TUID, and Subcategory fields
-- =============================================
-- Updated by: Zach Ventimiglia
-- Update Date: 4/3/2025
-- Description: Added EDITOR_ID field and made the update search that field
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Floorset_Fixture]
(
	@TUID INT = NULL,
	@FLOORSET_TUID INT,
	@FIXTURE_TUID INT,
	@EDITOR_ID INT,
	@XPOS INT,
	@YPOS INT,
	@HANGER_STACK INT = 1,
	--@TOT_LF INT,
	@ALLOCATED_LF INT = NULL,
	@SUPERCATEGORY_TUID INT = NULL, 
	@SUBCATEGORY VARCHAR(100) = NULL,
	@NOTE VARCHAR(1000) = NULL
)
AS
BEGIN
	BEGIN TRY

	--DECLARE @TOT_LF INT = ((@HANGER_STACK) * (SELECT LF_CAP FROM Fixtures WHERE TUID = @FIXTURE_TUID))

	IF @TUID IS NULL
		BEGIN
			INSERT INTO [dbo].[Floorsets_Fixtures]
			(
				FLOORSET_TUID,
				FIXTURE_TUID,
				EDITOR_ID,
				X_POS,
				Y_POS,
				HANGER_STACK,
				--TOT_LF,
				ALLOCATED_LF,
				SUPERCATEGORY_TUID,
				SUBCATEGORY,
				NOTE
			)
			VALUES
			(
				@FLOORSET_TUID,
				@FIXTURE_TUID,
				@EDITOR_ID,
				@XPOS,
				@YPOS,
				@HANGER_STACK,
				--@TOT_LF,
				@ALLOCATED_LF,
				COALESCE(@SUPERCATEGORY_TUID, 0),
				@SUBCATEGORY,
				COALESCE(@NOTE, '')
			) 
			SELECT 200 AS Response
		END
	ELSE
		BEGIN
			UPDATE [dbo].[Floorsets_Fixtures]
			SET
				X_POS = COALESCE(@XPOS, X_POS),
				Y_POS = COALESCE(@YPOS, Y_POS),
				HANGER_STACK = COALESCE(@HANGER_STACK, HANGER_STACK),
				--TOT_LF = COALESCE(@TOT_LF, TOT_LF),
				ALLOCATED_LF = COALESCE(@ALLOCATED_LF, ALLOCATED_LF),
				SUPERCATEGORY_TUID = COALESCE(@SUPERCATEGORY_TUID, SUPERCATEGORY_TUID),
				SUBCATEGORY = COALESCE(@SUBCATEGORY, SUBCATEGORY),
				NOTE = COALESCE(@NOTE, NOTE)
			WHERE EDITOR_ID = @EDITOR_ID AND
				FLOORSET_TUID = @FLOORSET_TUID
			SELECT 200 AS Response
		END
	END TRY
	BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END
		
GO