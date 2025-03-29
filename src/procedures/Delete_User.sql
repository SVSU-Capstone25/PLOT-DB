SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* 
	Filename: Delete_Access.sql

	File Purpose: Revoke access for a given
	user to a given store.
	
	Written By: Andrew Miller
*/

/*
Filename: Delete_User.sql
Part of Project: PLOT/PLOT-DB/src/procedures

File Purpose:
This file contains the stored procedure for "deleting" a user.
Since information on "deleted" users is still needed in the
floorsets table the "Active" column in the users table is set
to 0 to indicate inactive.

All rows with the user_tuid is then removed from the access table.
*/

CREATE OR ALTER PROCEDURE [dbo].[Delete_User]
    --  Stored procedure to delete (inactivate) user
    --  make user "ACTIVE" column inactive i.e. 0

    @UserId INT -- Id of user to be deleted

AS
BEGIN
    BEGIN TRY
        -- Check if the user exists
        IF EXISTS (SELECT 1 FROM Users WHERE TUID = @UserId)

        -- User exists - change to inactive
        BEGIN
            -- Update the Users table to set user as inactive
            UPDATE Users
            SET ACTIVE = 0
            WHERE TUID = @UserId;

            -- Delete from the access table where user exists
            DELETE FROM access
            WHERE USER_TUID = @UserId;

            -- Successful response
            SELECT 'OK 200' AS Response;
        END

        ELSE
        -- User does not exist
        BEGIN
            -- Failed response
            SELECT 'NOT FOUND 404' As Response;
        END;

    END TRY

    BEGIN CATCH
        -- Error
        SELECT ERROR_MESSAGE() As Response;
    END CATCH

END;
GO