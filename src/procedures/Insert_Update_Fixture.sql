SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 2/13/2025
-- Description: 
-- This Procedure inserts or updates a row to the Fixtures table
-- by using the TUID and if its null, it inserts a row. Else it will update the row manipulated.
-- =============================================
-- Update: 4/2/2025
-- By: Andrew Miller
-- Description: Changed "height" to "length"
CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Fixture]
(
	@TUID INT = NULL,
	@NAME VARCHAR(100) = NULL,
	@WIDTH INT = NULL,
	@LENGTH INT = NULL,
	@LF_CAP DECIMAL(10,2) = NULL,
	@ICON VARBINARY(MAX) = NULL,
	@STORE_TUID INT = NULL
)
AS
BEGIN
BEGIN TRY
	IF @TUID IS NULL
		BEGIN
			INSERT INTO [dbo].[Fixtures]
			(
				NAME,
				WIDTH,
				LENGTH,
				LF_CAP,
				ICON,
				STORE_TUID
			)
			VALUES
			(
				@NAME,
				@WIDTH,
				@LENGTH,
				@LF_CAP,
				@ICON,
				@STORE_TUID
			) 
			SELECT 'OK 200' AS Response
		END
	ELSE
		BEGIN
			UPDATE [dbo].[Fixtures]
			SET
				NAME = @NAME,
				WIDTH = @WIDTH,
				LENGTH = @LENGTH,
				LF_CAP = @LF_CAP,
				ICON = @ICON,
				STORE_TUID = @STORE_TUID
			WHERE TUID = @TUID
			SELECT 'OK 200' AS Response
		END
	END TRY
	BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END
GO