/* 
	Filename: update_users.sql

	File Purpose: Trigger for when the users
    table is updated.

    When users table is updated to change role
    tuid to 3 (employee tuid),
    then store access is revoked.

    What this enforces is that store access is
    for owner and manager accounts only.
	
	Written By: Andrew Miller
*/

CREATE TRIGGER update_users
ON users
AFTER UPDATE
AS
BEGIN
    
    -- If the user being updated is an employee
    IF EXISTS (SELECT 1 FROM inserted WHERE role_tuid = 3)
    BEGIN

        -- Delete user tuids from the access table
        DELETE FROM access
        WHERE user_tuid IN (SELECT tuid FROM inserted);
    END
END;
GO