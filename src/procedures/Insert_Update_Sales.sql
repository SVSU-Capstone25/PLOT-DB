USE [sqlpreview]
GO

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
CREATE PROCEDURE [dbo].[Insert_Update_Sales]
(
    @ID INT = NULL,
	@FILENAME VARCHAR(100) = NULL,
	@FILEDATA VARBINARY(MAX) = NULL,
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
	IF @ID IS NULL
		BEGIN
			INSERT INTO Sales(FILENAME,FILEDATA,CAPTURE_DATE,DATE_UPLOADED,FLOORSET_TUID) 
			VALUES (@FILENAME,@FILEDATA,@CAPTURE_DATE,@DATE_UPLOADED,@FLOORSET_TUID);

			SELECT 'OK 200' AS Response;
		END
		
	ELSE
		BEGIN
			UPDATE Sales 
			SET FILENAME=@FILENAME,
				FILEDATA=@FILEDATA
			WHERE TUID=@ID
			
			SELECT 'OK 200' AS Response;
		END
	END TRY

    BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;

END
GO


