SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Andrew Miller
-- Create Date: <4/24/2025>
-- Description: <This procedure takes an instance of a floorset and copies it>
-- This involves the floorsets table, and then the tables with a foreign key referencing
-- the floorsets table, including floorsets_fixtures, sales, and employee_area.
-- Also, the sales_allocation table which has a foreign key to the sales table.
-- This is tailored to the current schema and will need modification
-- if changes to these tables or new tables referencing these tables are made in the future.
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[Copy_Fixtures_For_Floorset]
-- Inserts rows into fixtures_for_floorset identical except for replacing
-- the old floorset_tuid with a new one and having a new TUID for the row

    @OLD_FLOORSET_TUID INT,
    @NEW_FLOORSET_TUID INT
AS
BEGIN
	-- Copies values into all categories of Floorsets_Fixtures for each row with FLOORSET_TUID of OLD_FLOORSET_TUID, only changing the FLOORSET_TUID to NEW_FLOORSET_TUID
    INSERT INTO FLOORSETS_FIXTURES (FLOORSET_TUID, FIXTURE_TUID, X_POS, Y_POS, HANGER_STACK, SUBCATEGORY, NOTE, SUPERCATEGORY_TUID, FIXTURE_IDENTIFIER)
    SELECT 
        @NEW_FLOORSET_TUID,
        FIXTURE_TUID,
        X_POS,
        Y_POS,
        HANGER_STACK,
        SUBCATEGORY,
        NOTE,
        SUPERCATEGORY_TUID,
        FIXTURE_IDENTIFIER
    FROM FLOORSETS_FIXTURES
    WHERE FLOORSET_TUID = @OLD_FLOORSET_TUID;

END
GO

CREATE OR ALTER PROCEDURE [dbo].[Copy_Employee_Areas_For_Floorset]
-- Inserts rows into employee areas identical except for replacing
-- the old floorset_tuid with a new one and having a new TUID for the row

    @OLD_FLOORSET_TUID INT,
    @NEW_FLOORSET_TUID INT
AS
BEGIN
	-- Copies values into the columns (X_POS and Y_POS) of the Employee_Area table for each row with FLOORSET_TUID of OLD_FLOORSET_TUID,
	-- only changing the FLOORSET_TUID to NEW_FLOORSET_TUID
    INSERT INTO EMPLOYEE_AREA (FLOORSET_TUID,X_POS, Y_POS)
    SELECT
        @NEW_FLOORSET_TUID,
        X_POS,
        Y_POS
    FROM EMPLOYEE_AREA
    WHERE FLOORSET_TUID = @OLD_FLOORSET_TUID;

END
GO

CREATE OR ALTER PROCEDURE [dbo].[Copy_Sales_Allocations_For_Floorset]
-- Inserts rows into sales allocation identical except for replacing
-- the old sales_tuid with a new one and having a new TUID for the row

    @OLD_SALES_TUID INT,
    @NEW_SALES_TUID INT
AS
BEGIN
	-- Copies values into the columns of sales allocation, excluding TUID and SALES_TUID is
    -- replaced with the copied Sales TUID
    INSERT INTO SALES_ALLOCATION (SUPERCATEGORY_TUID, SUBCATEGORY, TOTAL_SALES, SALES_TUID)
    SELECT
        SUPERCATEGORY_TUID,
        SUBCATEGORY,
        TOTAL_SALES,
        @NEW_SALES_TUID
    FROM SALES_ALLOCATION
    WHERE SALES_TUID = @OLD_SALES_TUID

END
GO

CREATE OR ALTER PROCEDURE [dbo].[Copy_Sales_For_Floorset]
-- Inserts rows into sales identical except for replacing
-- the old floorset_tuid with a new one and having a new TUID for the row
-- Also sets Date_uploaded to present using GETDATE() and adds a timestamp
-- to the Filename to prevent an error since PLOT expects it to be unique
-- Filename comes out in format:
--  filename.extension ---> filename_yyyyMMdd_HHmmss.extension
    @OLD_FLOORSET_TUID INT,
    @NEW_FLOORSET_TUID INT
AS
BEGIN
	DECLARE @OLD_SALES_TUID INT, @NEW_SALES_TUID INT
	-- Declare cursor to iterate through results in sales table
	-- that have the foreign key of the floorset table being copied
	DECLARE SALES_CURSOR CURSOR FOR
		SELECT TUID
		FROM SALES
		WHERE FLOORSET_TUID = @OLD_FLOORSET_TUID;

	OPEN SALES_CURSOR;

	FETCH NEXT FROM SALES_CURSOR INTO @OLD_SALES_TUID;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO SALES (FILENAME, FILEDATA, CAPTURE_DATE, DATE_UPLOADED, FLOORSET_TUID)
			SELECT
			LEFT(FILENAME, LEN(FILENAME) - CHARINDEX('.', REVERSE(FILENAME))) 
			+ '_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + 
            '.' + RIGHT(FILENAME, CHARINDEX('.', REVERSE(FILENAME)) - 1),
			FILEDATA,
			CAPTURE_DATE,
			GETDATE(),
			@NEW_FLOORSET_TUID
		FROM SALES
		WHERE TUID = @OLD_SALES_TUID;

		-- Set New sales tuid as the new tuid in Sales
		SET @NEW_SALES_TUID = SCOPE_IDENTITY();

		-- Copy data in Sales Allocation table referencing the old sales tuid and the new sales tuid
		EXEC Copy_Sales_Allocations_For_Floorset @OLD_SALES_TUID, @NEW_SALES_TUID;

		FETCH NEXT FROM SALES_CURSOR INTO @OLD_SALES_TUID;
	END

    CLOSE SALES_CURSOR;
    DEALLOCATE SALES_CURSOR;

END
GO

CREATE OR ALTER PROCEDURE [dbo].[Copy_Floorset]
    @OLD_FLOORSET_TUID INT
AS
BEGIN
    SET NOCOUNT ON;
     -- NEW_FLOORSET_TUID is for the new copied Floorset's TUID, others hold old values from floorset
    DECLARE @NEW_FLOORSET_TUID INT, @FLOORSET_NAME VARCHAR(100), @STORE_TUID INT, @FLOORSET_IMAGE VARBINARY(MAX)

    BEGIN TRANSACTION;
    BEGIN TRY

    IF @OLD_FLOORSET_TUID IS NULL
    BEGIN
        RAISERROR('OLD_FLOORSET_TUID given as null.', 16, 1);
    END

    -- Select floorset row columns to copy, add 'Copy' to new name
    SELECT TOP (1)
        @FLOORSET_NAME = Name + ' Copy',
        @STORE_TUID = STORE_TUID,
        @FLOORSET_IMAGE = FLOORSET_IMAGE
    FROM FLOORSETS
    WHERE TUID = @OLD_FLOORSET_TUID;

    IF @FLOORSET_NAME IS NULL
    BEGIN
        RAISERROR('New floorset Name failed to set', 16, 1);
    END

    -- Insert copied floorset
    INSERT INTO FLOORSETS (Name, STORE_TUID, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY, FLOORSET_IMAGE)
    VALUES (@FLOORSET_NAME, @STORE_TUID, GETDATE(), -1, GETDATE(), -1, @FLOORSET_IMAGE);

	-- Get new floorset's TUID
    SET @NEW_FLOORSET_TUID = SCOPE_IDENTITY();

    -- Copy data in tables with foreign keys to floorsets:
	EXEC [dbo].[Copy_Fixtures_For_Floorset] @OLD_FLOORSET_TUID, @NEW_FLOORSET_TUID

    EXEC [dbo].[Copy_Employee_Areas_For_Floorset] @OLD_FLOORSET_TUID, @NEW_FLOORSET_TUID

	EXEC [dbo].[Copy_Sales_For_Floorset] @OLD_FLOORSET_TUID, @NEW_FLOORSET_TUID
    -- Send new floorset TUID and success code
    SELECT 200 AS Response;
    COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
            SELECT 
            500 AS Response,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_LINE() AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState;    
    END CATCH
END
GO
