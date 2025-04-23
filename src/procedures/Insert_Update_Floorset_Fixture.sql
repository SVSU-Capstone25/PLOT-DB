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
CREATE OR ALTER PROCEDURE [dbo].[Insert_Floorset_Fixture]
(
	@FLOORSET_TUID INT,
	@FIXTURE_TUID INT,
	@EDITOR_ID INT,
	@FIXTURE_IDENTIFIER VARCHAR(100) = NULL,
	@XPOS INT,
	@YPOS INT,
	@HANGER_STACK INT = NULL,
	@ALLOCATED_LF INT = NULL,
	@SUPERCATEGORY_TUID INT = NULL, 
	@SUBCATEGORY VARCHAR(100) = NULL,
	@NOTE VARCHAR(1000) = NULL
)
AS
BEGIN
	INSERT INTO [dbo].[Floorsets_Fixtures]
	(
		FLOORSET_TUID,
		FIXTURE_TUID,
		EDITOR_ID,
		FIXTURE_IDENTIFIER,
		X_POS,
		Y_POS,
		HANGER_STACK,
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
		@FIXTURE_IDENTIFIER,
		@XPOS,
		@YPOS,
		COALESCE(@HANGER_STACK, 1),
		COALESCE(@ALLOCATED_LF, 0),
		COALESCE(@SUPERCATEGORY_TUID, 0),
		@SUBCATEGORY,
		COALESCE(@NOTE, '')
	) 
	SELECT SCOPE_IDENTITY();
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Update_Floorset_Fixture]
(
	@TUID INT,
	@FLOORSET_TUID INT,
	@EDITOR_ID INT,
	@FIXTURE_IDENTIFIER VARCHAR(100) = NULL,
	@XPOS INT = NULL,
	@YPOS INT = NULL,
	@HANGER_STACK INT = NULL,
	@ALLOCATED_LF INT = NULL,
	@SUPERCATEGORY_TUID INT = NULL, 
	@SUBCATEGORY VARCHAR(100) = NULL,
	@NOTE VARCHAR(1000) = NULL
)
AS
BEGIN
	UPDATE [dbo].[Floorsets_Fixtures]
	SET
		X_POS = COALESCE(@XPOS, X_POS),
		Y_POS = COALESCE(@YPOS, Y_POS),
		HANGER_STACK = COALESCE(@HANGER_STACK, HANGER_STACK),
		ALLOCATED_LF = COALESCE(@ALLOCATED_LF, ALLOCATED_LF),
		SUPERCATEGORY_TUID = COALESCE(@SUPERCATEGORY_TUID, SUPERCATEGORY_TUID),
		SUBCATEGORY = COALESCE(@SUBCATEGORY, SUBCATEGORY),
		NOTE = COALESCE(@NOTE, NOTE),
		FIXTURE_IDENTIFIER = COALESCE(@FIXTURE_IDENTIFIER, FIXTURE_IDENTIFIER)
	WHERE EDITOR_ID = @EDITOR_ID AND
		FLOORSET_TUID = @FLOORSET_TUID
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Floorset_Fixture]
(	
	@TUID INT = NULL,
	@FLOORSET_TUID INT,
	@EDITOR_ID INT,
	@FIXTURE_TUID INT = NULL,
	@FIXTURE_IDENTIFIER VARCHAR(100) = NULL,
	@XPOS INT = NULL,
	@YPOS INT = NULL,
	@HANGER_STACK INT = NULL,
	@ALLOCATED_LF INT = NULL,
	@SUPERCATEGORY_TUID INT = NULL, 
	@SUBCATEGORY VARCHAR(100) = NULL,
	@NOTE VARCHAR(1000) = NULL
)
AS
BEGIN
	BEGIN TRY
		DECLARE @WIDTH INT, @LENGTH INT;

		-- Get Store dimensions using the Floorset
		SELECT @WIDTH = S.WIDTH, @LENGTH = S.LENGTH
		FROM Floorsets F
		JOIN Stores S ON F.STORE_TUID = S.TUID
		WHERE F.TUID = @FLOORSET_TUID;

		-- Check if the X/Y position is within bounds
		IF @XPOS < 0 OR @YPOS < 0 OR @XPOS >= @WIDTH OR @YPOS >= @LENGTH
		BEGIN
			RAISERROR('X_POS or Y_POS out of store bounds.', 16, 1);
			RETURN;
		END

		-- Check for duplicate position
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
		ELSE
		BEGIN
			RAISERROR('This X_POS and Y_POS is already occupied for this FLOORSET.', 16, 1);
		END
	END TRY
	BEGIN CATCH
		SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
	END CATCH
END
GO