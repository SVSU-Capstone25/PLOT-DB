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
-- Updated by: Zach Ventimiglia
-- Update Date: 4/21/2025
-- Description: Limit duplicate x and y position (so they wont line up 
-- on the same floorset)
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
	@ALLOCATED_LF INT = 0,
	@SUPERCATEGORY_TUID INT = NULL, 
	@SUBCATEGORY VARCHAR(100) = NULL,
	@NOTE VARCHAR(1000) = NULL,
	@FIXTURE_IDENTIFIER VARCHAR(100) = NULL
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (
		SELECT 1 
			FROM Floorsets_Fixtures 
			WHERE FLOORSET_TUID = @FLOORSET_TUID AND
				X_POS = @XPOS AND Y_POS = @YPOS
		)

		BEGIN
		IF @TUID IS NULL
			BEGIN
				EXEC [dbo].[Insert_Floorset_Fixture] 
					@FLOORSET_TUID,
					@FIXTURE_TUID,
					@EDITOR_ID,
					@FIXTURE_IDENTIFIER,
					@XPOS,
					@YPOS,
					@HANGER_STACK,
					@ALLOCATED_LF,
					@SUPERCATEGORY_TUID,
					@SUBCATEGORY,
					@NOTE
			END
		ELSE
			BEGIN
				EXEC [dbo].[Update_Floorset_Fixture]
					@TUID,
					@FLOORSET_TUID,
					@EDITOR_ID,
					@FIXTURE_IDENTIFIER,
					@XPOS,
					@YPOS,
					@HANGER_STACK,
					@ALLOCATED_LF,
					@SUPERCATEGORY_TUID,
					@SUBCATEGORY,
					@NOTE
			END
			SELECT 200 AS Response
		END
	END TRY
	BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END
		
GO