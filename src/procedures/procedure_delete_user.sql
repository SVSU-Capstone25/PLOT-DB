/*
Filename: procedure_delete_user.sql
Part of Project: PLOT/PLOT-DB/src/procedures

File Purpose:
This file contains the stored procedure for "deleting" a user.
Since information on "deleted" users is still needed in the
floorsets table the "Active" column in the users table is set
to 0 to indicate inactive.
*/

--  Stored procedure to delete (inactivate) user
--  make user "ACTIVE" column inactive i.e. 0
CREATE PROCEDURE procedure_delete_user
    @UserId INT, -- Id of user to be deleted
    @ResultMessage NVARCHAR(255) OUTPUT -- Output message
    -- success or fail or error
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

            -- Set the output message for success
            SET @ResultMessage = 'OK 200';
        END

        ELSE
        -- User does not exist
        BEGIN
            -- User not found in users table
            SET @ResultMessage = 'NOT FOUND 404';
        END;

    END TRY

    BEGIN CATCH
        -- Error
        SET @ResultMessage = ERROR_MESSAGE();
    END CATCH

END;
GO
