SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Krzysztof,Hejno>
-- Create Date: <2/14/2025>
-- Description: <This procedure adds a new floorset to the table if ID is not provided, or updates the floorset with a given ID.>
-- =============================================
-- Updated By: Zach Ventimiglia
-- Date: 4/5/2025
-- Description: Added the new column for insertion
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[Insert_Floorset]
(
    @TUID INT = NULL,
	@NAME VARCHAR(100) = NULL,
	@STORE_TUID INT = NULL,
	@DATE_CREATED DATETIME = NULL,
	@CREATED_BY INT = NULL,
	@DATE_MODIFIED DATETIME = NULL,
	@MODIFIED_BY INT = NULL,
	@FLOORSET_IMAGE VARBINARY(MAX) = NULL
)
AS
BEGIN
	INSERT INTO Floorsets 
	(
		NAME,
		STORE_TUID,
		DATE_CREATED,
		CREATED_BY,
		DATE_MODIFIED,
		MODIFIED_BY,
		FLOORSET_IMAGE
	) 
	VALUES 
	(
		@NAME,
		@STORE_TUID,
		@DATE_CREATED,
		@CREATED_BY,
		@DATE_MODIFIED,
		@MODIFIED_BY,
		@FLOORSET_IMAGE
	);
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Update_Floorset]
(
    @TUID INT,
	@NAME VARCHAR(100) = NULL,
	@STORE_TUID INT = NULL,
	@DATE_MODIFIED DATETIME = NULL,
	@MODIFIED_BY INT = NULL,
	@FLOORSET_IMAGE VARBINARY(MAX) = NULL
)
AS
BEGIN
	UPDATE Floorsets 
	SET NAME = COALESCE(@NAME, NAME),
		STORE_TUID = COALESCE(@STORE_TUID, STORE_TUID),
		DATE_MODIFIED = COALESCE(@DATE_MODIFIED, DATE_MODIFIED),
		MODIFIED_BY = COALESCE(@MODIFIED_BY, MODIFIED_BY),
		@FLOORSET_IMAGE = COALESCE(@FLOORSET_IMAGE, FLOORSET_IMAGE)
	WHERE TUID = @TUID
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Insert_Update_Floorset]
(
    @TUID INT = NULL,
	@NAME VARCHAR(100) = NULL,
	@STORE_TUID INT = NULL,
	@DATE_CREATED DATETIME = NULL,
	@CREATED_BY INT = NULL,
	@DATE_MODIFIED DATETIME = NULL,
	@MODIFIED_BY INT = NULL,
	@FLOORSET_IMAGE VARBINARY(MAX) = NULL
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	BEGIN TRY
	IF @TUID IS NULL
		BEGIN
			EXEC [dbo].[Insert_Floorset] @NAME, @STORE_TUID, @DATE_CREATED, @CREATED_BY, @DATE_MODIFIED, @MODIFIED_BY, @FLOORSET_IMAGE
		END
		
	ELSE
		BEGIN
			
			EXEC [dbo].[Insert_Floorset] @NAME, @STORE_TUID, @DATE_MODIFIED, @MODIFIED_BY, @FLOORSET_IMAGE
		END

	SELECT 200 AS Response;
	END TRY

    BEGIN CATCH
        -- If insert fails, return ERROR 500
        SELECT 500 AS Response, ERROR_MESSAGE() AS ErrorDetails;
    END CATCH;

END

GO
