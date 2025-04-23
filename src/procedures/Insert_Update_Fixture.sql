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
CREATE OR ALTER PROCEDURE [dbo].[Insert_Fixture]
(
	@NAME VARCHAR(100),
	@WIDTH INT,
	@LENGTH INT,
	@ICON VARBINARY(MAX),
	@STORE_TUID INT,
	@LF_CAP INT = NULL
)
AS
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
		COALESCE(@LF_CAP, 1),
		@ICON,
		@STORE_TUID
	) 
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Update_Fixture]
(
	@TUID INT,
	@NAME VARCHAR(100) = NULL,
	@WIDTH INT = NULL,
	@LENGTH INT = NULL,
	@ICON VARBINARY(MAX) = NULL,
	@STORE_TUID INT = NULL,
	@LF_CAP INT = NULL
)
AS
BEGIN
	UPDATE [dbo].[Fixtures]
	SET
		NAME = COALESCE(@NAME, NAME),
		WIDTH = COALESCE(@WIDTH, WIDTH),
		LENGTH = COALESCE(@LENGTH, LENGTH),
		ICON = COALESCE(@ICON, ICON),
		STORE_TUID = COALESCE(@STORE_TUID, STORE_TUID),
		LF_CAP = COALESCE(@LF_CAP, LF_CAP)
	WHERE TUID = @TUID
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Fixture]
(
	@TUID INT = NULL,
	@NAME VARCHAR(100) = NULL,
	@WIDTH INT = NULL,
	@LENGTH INT = NULL,
	@ICON VARBINARY(MAX) = NULL,
	@STORE_TUID INT = NULL,
	@LF_CAP INT = NULL
)
AS
BEGIN
BEGIN TRY
	IF @TUID IS NULL
		BEGIN
			EXEC [dbo].[Insert_Fixture] @NAME, @WIDTH, @LENGTH, @ICON, @STORE_TUID, @LF_CAP
		END
	ELSE
		BEGIN
			EXEC [dbo].[Update_Fixture] @TUID, @NAME, @WIDTH, @LENGTH, @ICON, @STORE_TUID, @LF_CAP
		END

	SELECT 200 AS Response
	END TRY
	BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;
END
GO