/****** Object:  StoredProcedure [dbo].[Insert_Update_Sales]    Script Date: 3/29/2025 1:32:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:      <Krzysztof,Hejno>
-- Create Date: <2/14/2025>
-- Description: <This procedure adds new sales data to the table if ID is not provided, or updates the sales data's FILENAME or FILEDATA with a given ID.>
-- =============================================
-- Update: 4/2/2025
-- By: Andrew Miller
-- Description: Removed USE [sqlpreview] statement. Caused bugs when testing locally.
-- While it doesn't appear to have caused bugs in Docker, since it was accepted into main before,
-- it wouldn't have a functional role to play, and risks introducing bugs in the future.
CREATE OR ALTER PROCEDURE [dbo].[Insert_Sales_File]
(
	@FILE_NAME VARCHAR(100) = NULL,
	@FILE_DATA VARBINARY(MAX) = NULL,
	@CAPTURE_DATE DATETIME = NULL,
	@DATE_UPLOADED DATETIME = NULL,
	@FLOORSET_TUID INT = NULL
)
AS
BEGIN
	INSERT INTO Sales
	(
		FILENAME,
		FILEDATA,
		CAPTURE_DATE,
		DATE_UPLOADED,
		FLOORSET_TUID
	) 
	VALUES 
	(
		@FILE_NAME,
		@FILE_DATA,
		@CAPTURE_DATE,
		@DATE_UPLOADED,
		@FLOORSET_TUID
	);
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Update_Sales_File]
(
    @TUID INT,
	@FILE_NAME VARCHAR(100) = NULL,
	@FILE_DATA VARBINARY(MAX) = NULL,
	@DATE_UPLOADED DATETIME = NULL
)
AS
BEGIN
	UPDATE Sales 
	SET FILENAME = COALESCE(@FILE_NAME, FILENAME),
		FILEDATA = COALESCE(@FILE_DATA, FILEDATA),
		DATE_UPLOADED = COALESCE(@DATE_UPLOADED, DATE_UPLOADED)
	WHERE TUID = @TUID
END 
GO

CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Sales_File]
(
    @TUID INT = NULL,
	@FILE_NAME VARCHAR(100) = NULL,
	@FILE_DATA VARBINARY(MAX) = NULL,
	@CAPTURE_DATE DATETIME = NULL,
	@DATE_UPLOADED DATETIME = NULL,
	@FLOORSET_TUID INT = NULL
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	BEGIN TRY
		IF @TUID IS NULL
		BEGIN
			EXEC [dbo].[Insert_Sales_File] @FILE_NAME, @FILE_DATA, @CAPTURE_DATE, @DATE_UPLOADED, @FLOORSET_TUID
		END
		
		ELSE
		BEGIN
			EXEC [dbo].[Update_Sales_File] @TUID, @FILE_NAME, @FILE_DATA, @DATE_UPLOADED
		END

		SELECT 200 AS Response;
	END TRY

    BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;

END
GO
