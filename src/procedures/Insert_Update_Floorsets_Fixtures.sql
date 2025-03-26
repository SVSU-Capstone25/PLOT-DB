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
CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Floorsets_Fixtures]
(
	@ID INT = NULL,
	@FLOORSET_TUID INT,
	@FIXTURE_TUID INT,
	@XPOS DECIMAL(9,6) = NULL,
	@YPOS DECIMAL(9,6) = NULL,
	@HANGER_STACK INT = NULL,
	@TOT_LF DECIMAL(10,2) = NULL,
	@ALLOCATED_LF DECIMAL(10,2) = NULL,
	@CATEGORY VARCHAR(100) = NULL,
	@NOTE VARCHAR(1000) = NULL
)
AS
BEGIN
	BEGIN TRY
	IF @ID IS NULL
		BEGIN
			INSERT INTO [dbo].[Floorsets_Fixtures]
			(
				FLOORSET_TUID,
				FIXTURE_TUID,
				X_POS,
				Y_POS,
				HANGER_STACK,
				TOT_LF,
				ALLOCATED_LF,
				CATEGORY,
				NOTE
			)
			VALUES
			(
				@FLOORSET_TUID,
				@FIXTURE_TUID,
				@XPOS,
				@YPOS,
				@HANGER_STACK,
				@TOT_LF,
				@ALLOCATED_LF,
				@CATEGORY,
				@NOTE
			) 
			SELECT 'OK 200' AS Response
		END
	ELSE
		BEGIN
			UPDATE [dbo].[Floorsets_Fixtures]
			SET
				X_POS = @XPOS,
				Y_POS = @YPOS,
				HANGER_STACK = @HANGER_STACK,
				TOT_LF = @TOT_LF,
				ALLOCATED_LF = @ALLOCATED_LF,
				CATEGORY = @CATEGORY,
				NOTE = @NOTE
			WHERE TUID = @ID
			SELECT 'OK 200' AS Response
		END
	END TRY
	BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END
		
GO