-- =============================================
-- Author:      <Krzysztof,Hejno>
-- Create Date: <2/14/2025>
-- Description: <This procedure adds a new floorset to the table if ID is not provided, or updates the floorset with a given ID.>
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Update_Floorsets]
(
    @ID INT = NULL,
	@NAME VARCHAR(100) = NULL,
	@STORE_TUID INT = NULL,
	@DATE_CREATED DATETIME = NULL,
	@CREATED_BY INT = NULL,
	@DATE_MODIFIED DATETIME = NULL,
	@MODIFIED_BY INT = NULL
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	BEGIN TRY
	IF @ID IS NULL
		BEGIN
			INSERT INTO Floorsets (NAME,STORE_TUID,DATE_CREATED,CREATED_BY,DATE_MODIFIED,MODIFIED_BY) 
			VALUES (@NAME,@STORE_TUID,@DATE_CREATED,@CREATED_BY,@DATE_MODIFIED,@MODIFIED_BY);

			SELECT 'OK 200' AS Response
		END
		
	ELSE
		BEGIN
			UPDATE Floorsets 
			SET NAME=@NAME,
				STORE_TUID=@STORE_TUID,
				DATE_CREATED=@DATE_CREATED,
				CREATED_BY=@CREATED_BY,
				DATE_MODIFIED=@DATE_MODIFIED,
				MODIFIED_BY=@MODIFIED_BY
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

