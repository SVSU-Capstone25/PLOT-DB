-- =============================================
-- Author:      <Krzysztof,Hejno>
-- Create Date: <2/11/2025>
-- Description: <This procedure finds the store TUID to attach the floorset to and adds a new floorset to the table based on multiple parameters.>
-- =============================================
CREATE PROCEDURE [dbo].[AddNewFloorset]
(
    @StoreName varchar(100),
	@Name varchar(100),
	@CreatedBy int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	BEGIN TRY
		INSERT INTO Floorsets (NAME,STORE_TUID,DATE_CREATED,CREATED_BY,DATE_MODIFIED,MODIFIED_BY) 
		VALUES (@Name,(SELECT TUID FROM dbo.GetStoreInfoByName(@StoreName)),GETDATE(),@CreatedBy,GETDATE(),@CreatedBy);

		SELECT 'OK 200' AS Response;
	END TRY
    BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 'ERROR 500' AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;

END
GO

