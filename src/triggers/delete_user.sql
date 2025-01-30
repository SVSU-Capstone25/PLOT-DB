/*
Filenname: delete_user.sql
Part of Project: PLOT/PLOT-DB/src/triggers

File Purpose:
Trigger so that when a user is deleted from the users table:

-User Ids in the User_TUID field in the access table are deleted.

-User Ids in the created_by field in the floorsets table are set to null.

-User Ids in the modified_by field in the floorsets table are set to null.

Setting to null in the floorsets table is so the user can be remove
while retaining floorsets that may still be in use.

Written by: Andrew Miller
*/

CREATE TRIGGER Delete_User
ON dbo.USERS
AFTER DELETE
AS
BEGIN
    DELETE FROM ACCESS
    WHERE USER_TUID IN (SELECT TUID FROM deleted);

	UPDATE FLOORSETS
	SET CREATED_BY = NULL
	WHERE CREATED_BY IN (SELECT TUID FROM deleted);

	UPDATE FLOORSETS
	SET MODIFIED_BY = NULL
	WHERE MODIFIED_BY IN (SELECT TUID FROM deleted);
END;