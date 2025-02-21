/*
Filename: Insert_Update_Stores.sql
Part of Project: PLOT/PLOT-DB/src/procedures

File Purpose:
This file contains the Stored Procedure for inserting and updating the Store table.
This also inserts the users into the access table for thea store.

Written by: Andrew Fulton
*/

ALTER PROCEDURE Insert_Update_Stores
    --TUID null for deciding if it should insert or update
	@TUID INT = NULL,  
    @NAME VARCHAR(100),
    @ADDRESS VARCHAR(100),
    @CITY VARCHAR(100),
    @STATE VARCHAR(25),
    @ZIP VARCHAR(10),
    @WIDTH INT,
    @HEIGHT INT,
    @BLUEPRINT_IMAGE VARBINARY(MAX),
    @UserTUIDs VARCHAR(MAX) --Comma seperated list of user TUIDs
AS
BEGIN
    --show number of rows affected
    SET NOCOUNT ON;

    --IF @TUID is NULL or 0, insert a new store
    IF @TUID IS NULL OR @TUID = 0
    BEGIN
        --insert the new store
        INSERT INTO Store(NAME, ADDRESS, CITY, STATE, ZIP, WIDTH, HEIGHT, BLUEPRINT_IMAGE)
        VALUES 
		(@NAME, @ADDRESS, @CITY, @STATE, @ZIP, @WIDTH, @HEIGHT, @BLUEPRINT_IMAGE);

        --int to hold the new store TUID
        DECLARE @NewStoreTUID INT = SCOPE_IDENTITY();

        --INSERT all Owners into the Access table for the new store
        INSERT INTO Access (USER_TUID, STORE_TUID)
        SELECT Users.TUID, @NewStoreTUID
        FROM Users
        WHERE Users.ROLE_TUID = 1; --Owner TUID is 1 in DB

        --INSERT users into the Access table for the new store
        IF @UserTUIDs IS NOT NULL AND @UserTUIDs <> ''
        BEGIN
            INSERT INTO Access (USER_TUID, STORE_TUID)
            SELECT VALUE, @NewStoreTUID
            FROM STRING_SPLIT(@UserTUIDs, ',');
        END;

        --Return the newly inserted store TUID
        SELECT @NewStoreTUID AS NewTUID;
    END
    
    --ELSE: the store is updated instead 
	ELSE 
    BEGIN
        --UPDATE the store information
        UPDATE Store
        SET NAME = @NAME,
            ADDRESS = @ADDRESS,
            CITY = @CITY,
            STATE = @STATE,
            ZIP = @ZIP,
            WIDTH = @WIDTH,
            HEIGHT = @HEIGHT,
            BLUEPRINT_IMAGE = @BLUEPRINT_IMAGE
        WHERE TUID = @TUID;

        --DROP all users from the current store
        DELETE FROM Access
        WHERE STORE_TUID = @TUID;

        --INSERT all owners into Access for the store
        INSERT INTO Access (USER_TUID, STORE_TUID)
        SELECT Users.TUID, @TUID
        FROM Users
        WHERE Users.ROLE_TUID = 1; --Owner TUID is 1 in DB
        
        --INSERT users into the Access table for the store
        -- error will most likely be from owners trying to be inserted into the access table again
        IF @UserTUIDs IS NOT NULL AND @UserTUIDs <> ''
        BEGIN
            BEGIN TRY
                INSERT INTO Access (USER_TUID, STORE_TUID)
                SELECT VALUE, @TUID
                FROM STRING_SPLIT(@UserTUIDs, ',');
            END TRY
            BEGIN CATCH
                -- If the error is a duplicate key violation (error number 2627)
                IF ERROR_NUMBER() = 2627
                BEGIN
                    PRINT 'Duplicate key error ignored. Continuing execution...';
                END
            END CATCH;
        END;


        --Return the updated TUID
        SELECT @TUID AS UpdatedTUID;
    END
END;
